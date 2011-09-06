Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469Ab1IFM03 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 08:26:29 -0400
Received: from gretna.indigovision.com ([62.7.85.227]:38974 "EHLO
	gretna.indigovision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754372Ab1IFM0W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 08:26:22 -0400
From: Bruce Stenning <b.stenning@indigovision.com>
To: Tejun Heo <htejun@gmail.com>
CC: Mark Lord <kernel@teksavvy.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Jeff Garzik <jgarzik@pobox.com>
Date: Tue, 6 Sep 2011 13:26:19 +0100
Subject: RE: sata_mv port lockup on hotplug (kernel 2.6.38.2)
Thread-Topic: sata_mv port lockup on hotplug (kernel 2.6.38.2)
Thread-Index: AcxsR3qVsma9kNrcQci6tuL3n+jr+gAR4xXgAAAc1hA=
Message-ID: <C1438B59050E1B4C9482FF3266AD6BA32D8DA54B0E@gretna.indigovision.com>
References: <20110525094127.GF10146@htj.dyndns.org>
 <4DF20E03.9030502@teksavvy.com> <20110610140155.GJ15235@htj.dyndns.org>
 <4DF25526.9010800@teksavvy.com> <20110611121957.GA7980@mtj.dyndns.org>
 <4DF4F30B.70702@teksavvy.com> <20110613104856.GC16021@htj.dyndns.org>
 <C1438B59050E1B4C9482FF3266AD6BA32D8D984D03@gretna.indigovision.com>
 <20110902011305.GE2752@htj.dyndns.org>
 <C1438B59050E1B4C9482FF3266AD6BA32D8D9854F7@gretna.indigovision.com>
 <20110906034544.GB18425@mtj.dyndns.org> 
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, en-GB
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> ata4: EH complete
> Waking error handler thread
> scsi_eh_wakeup: succeeded
> scsi_schedule_eh: succeeded
> scsi_restart_operations: waking up host to restart
> Error handler scsi_eh_3 sleeping

Sorry, I hit 'send' before thinking fully.  A short while before the above,
the following was logged:

Waking error handler thread
scsi_eh_wakeup: succeeded
Error handler scsi_eh_3 waking up

This suggests that scsi_error_handler was indeed running when the subsequent
wake-up was attempted.

Bruce.


Latest News at: http://www.indigovision.com/index.php/en/news.html
