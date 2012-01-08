Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223Ab2AHLY0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 06:24:26 -0500
Received: from mail29.messagelabs.com ([216.82.249.147]:54787 "HELO
	mail29.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750967Ab2AHLYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 06:24:25 -0500
X-Env-Sender: peter.korsgaard@barco.com
X-Msg-Ref: server-16.tower-29.messagelabs.com!1326021862!6790078!1
X-Originating-IP: [32.58.34.230]
X-StarScan-Version: 6.4.3; banners=-,-,-
X-VirusChecked: Checked
thread-index: AczN+BHCO/Hb1RDsQSay+RfJDCxT2g==
From: "Peter Korsgaard" <peter.korsgaard@barco.com>
To: "Axel Lin" <axel.lin@gmail.com>
Content-Transfer-Encoding: 7bit
Cc: <linux-kernel@vger.kernel.org>,
        "Jean Delvare \(PC drivers, core\)" <khali@linux-fr.org>,
        "Ben Dooks \(embedded platforms\)" <ben-linux@fluff.org>,
        <linux-i2c@vger.kernel.org>
Subject: Re: [PATCH] i2c: convert gpio-i2cmux to use module_platform_driver()
References: <1325986552.4442.0.camel@phoenix>
X-message-flag: thor uptime: 167 days,  1:31, 15 users
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4913
Content-class: urn:content-classes:message
Date: Sun, 08 Jan 2012 12:24:21 +0100
Importance: normal
In-Reply-To: <1325986552.4442.0.camel@phoenix> (Axel Lin's message of "Sun, 08Jan 2012 09:35:52 +0800")
Message-ID: <874nw6e8t6.fsf@thor.barco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
X-OriginalArrivalTime: 08 Jan 2012 11:24:21.0995 (UTC) FILETIME=[11BAF3B0:01CCCDF8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "AL" == Axel Lin <axel.lin@gmail.com> writes:

AL> This patch converts gpio-i2cmux to use the module_platform_driver() macro which
AL> makes the code smaller and a bit simpler.

AL> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Peter Korsgaard <peter.korsgaard@barco.com>

-- 
Sorry about disclaimer - It's out of my control.
Bye, Peter Korsgaard


DISCLAIMER:
Unless indicated otherwise, the information contained in this message is privileged and confidential, and is intended only for the use of the addressee(s) named above and others who have been specifically authorized to receive it. If you are not the intended recipient, you are hereby notified that any dissemination, distribution or copying of this message and/or attachments is strictly prohibited. The company accepts no liability for any damage caused by any virus transmitted by this email. Furthermore, the company does not warrant a proper and complete transmission of this information, nor does it accept liability for any delays. If you have received this message in error, please contact the sender and delete the message. Thank you.
