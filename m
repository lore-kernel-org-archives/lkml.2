Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932142Ab1FUBV6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 21:21:58 -0400
Received: from antispam02.maxim-ic.com ([205.153.101.183]:36477 "EHLO
	antispam02.maxim-ic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932079Ab1FUBV5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 21:21:57 -0400
X-ASG-Debug-ID: 1308619315-02256b4f7c4b6f0005-xx1T2L
X-Barracuda-Envelope-From: Peter.Hsiang@maxim-ic.com
From: Peter Hsiang <Peter.Hsiang@maxim-ic.com>
To: Manuel Estrada Sainz <ranty@debian.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 20 Jun 2011 18:20:52 -0700
Subject: Getting request_firmware() filename info from user space
Thread-Topic: Getting request_firmware() filename info from user space
X-ASG-Orig-Subj: Getting request_firmware() filename info from user space
Thread-Index: AQHML7F2ZjWZAw0XnUypJQaJC8Eqmw==
Message-ID: <B2150E1E4418E1438554A300EA5040E40DDE603CE3@ITSVLEX06.it.maxim-ic.internal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Barracuda-Connect: maxdalex02.maxim-ic.internal[10.16.15.104]
X-Barracuda-Start-Time: 1308619316
X-Barracuda-URL: http://192.168.10.183:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.02
X-Barracuda-Spam-Status: No, SCORE=0.02 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=5.0 tests=THREAD_INDEX, THREAD_TOPIC
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.66652
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.01 THREAD_INDEX           thread-index: AcO7Y8iR61tzADqsRmmc5wNiFHEOig==
	0.01 THREAD_TOPIC           Thread-Topic: ...(Japanese Subject)...
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Using the kernel request_firmware() function, it seems one can send any file by:
    cat myfile.bin > /sys/class/firmware/xxxx/data

How does the user space code obtain the filename parameter specified in the request_firmware() call?

The documentation says $DEVPATH and $FIRMWARE variables are provided in 
the environment, but "echo $FIRMWARE" prints an empty string.

I loaded the driver with an & just so I can get the shell prompt back to start the sysfs script.
How would one load the driver and run the sysfs script to send the file from the same shell?

Thanks,

Peter

