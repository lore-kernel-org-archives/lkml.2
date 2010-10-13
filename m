Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708Ab0JMTIK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 15:08:10 -0400
Received: from nm16.bullet.mail.ukl.yahoo.com ([217.146.183.190]:20478 "HELO
	nm16.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752641Ab0JMTII convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 15:08:08 -0400
X-Greylist: delayed 353 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Oct 2010 15:08:08 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 3525.14757.bm@omp1032.mail.ukl.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.it;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=u6mqACY+qEdFmH16XocT7OR9Qrc0euqOMYzF5HYyAJxBpeV5H1QiftYhItKgwa/BOIN2ai4L9PcST8Oezl0A5QlHPMH1Ak4/nDH8gHknvNwIDd9JcjWlgObcnQs7H0KYZI69cKwYQmzhCmkzFyr7VbO/pHxhD4n0/Bt4ng4NSCI=;
Message-ID: <142752.33963.qm@web25408.mail.ukl.yahoo.com>
X-YMail-OSG: LZ0_zacVM1nD8ju9hBYkyEczPtKrbBX6CCFAJ9a5uiVZ1nA
 MCXdEAHPpiPhheOiyl6qqYgBazSAwizyRioLgI4_WSAV2hpOKbOQIHvs3s.K
 G3W2nBEf5cIgXaSIVq7GiLxoMOjjxX2CdOBOSdpk3olUUHzXXORjIEhHqRRY
 hwgHqZ6N9xk66onklfeF.p6X0eh6gTXj8Tz56q_dvg4B8nXzN4va7jqZCpDO
 Pt3B6nFGWie1fJ7wJEKw6NUq3tAyTFyQbT3U8vUE6XPMwnRl_.yB5aTmDdtc
 -
X-Mailer: YahooMailRC/504.5 YahooMailWebService/0.8.106.282862
Date: Wed, 13 Oct 2010 20:02:11 +0100 (BST)
From: fabio tirapelle <ftirapelle@yahoo.it>
Subject: Hauppauge WinTV-HVR-1120 on Unbuntu 10.04
To: linux-kernel@vger.kernel.org
Cc: bjorn.helgaas@hp.com
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

After upgrading from Ubuntu 9.10 to Ubuntu 10.04 my Hauppauge WinTV-HVR-1120 
(sometimes) doesn't work correctly.
I get random the following errors:

tda18271_write_regs: ERROR: idx = 0x5, len = 1, i2c_transfer returned: -5
tda18271_init: error -5 on line 826
tda18271_tune: error -5 on line 904
tda18271_set_params: error -5 on line 985

Part of dmesg of 11-OCT-2010

[   53.216153] DVB: registering new adapter (saa7133[0])
[   53.216156] DVB: registering adapter 2 frontend 0 (NXP TDA10048HN DVB-T)...
[   53.840013] tda10048_firmware_upload: waiting for firmware upload 
(dvb-fe-tda10048-1.0.fw)...
[   53.840019] saa7134 0000:01:06.0: firmware: requesting dvb-fe-tda10048-1.0.fw
[   53.880505] tda10048_firmware_upload: firmware read 24878 bytes.
[   53.880509] tda10048_firmware_upload: firmware uploading
[   58.280136] tda10048_firmware_upload: firmware uploaded
[   59.024537] tda18271_write_regs: ERROR: idx = 0x5, len = 1, i2c_transfer 
returned: -5
[   59.024541] tda18271c2_rf_tracking_filters_correction: error -5 on line 264
[   59.420153] tda18271_write_regs: ERROR: idx = 0x5, len = 1, i2c_transfer 
returned: -5
[   59.420157] tda18271_toggle_output: error -5 on line 47
[   91.004019] Clocksource tsc unstable (delta = -295012684 ns)
[  256.293639] eth0: link up.
[  256.294750] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[  263.523498] eth0: link down.
[  265.258740] eth0: link up.
[  266.460026] eth0: no IPv6 routers present
[ 9869.636167] tda18271_write_regs: ERROR: idx = 0x5, len = 1, i2c_transfer 
returned: -5
[ 9869.636178] tda18271_init: error -5 on line 826
[ 9872.636220] tda18271_write_regs: ERROR: idx = 0x5, len = 1, i2c_transfer 
returned: -5
[ 9872.636232] tda18271_toggle_output: error -5 on line 47
[ 9998.240167] tda18271_write_regs: ERROR: idx = 0x5, len = 1, i2c_transfer 
returned: -5
[ 9998.240178] tda18271_init: error -5 on line 826
[10001.240179] tda18271_write_regs: ERROR: idx = 0x5, len = 1, i2c_transfer 
returned: -5
[10001.240190] tda18271_toggle_output: error -5 on line 47

And this is the dmesg of today: even the same errors.

[  741.252183] tda18271_init: error -5 on line 826
[  741.252188] tda18271_tune: error -5 on line 904
[  741.252193] tda18271_set_params: error -5 on line 985
[  742.268174] tda18271_write_regs: ERROR: idx = 0x5, len = 1, i2c_transfer 
returned: -5
[  742.268184] tda18271_init: error -5 on line 826
[  742.268189] tda18271_tune: error -5 on line 904
[  742.268194] tda18271_set_params: error -5 on line 985
[  743.284174] tda18271_write_regs: ERROR: idx = 0x5, len = 1, i2c_transfer 
returned: -5
[  743.284184] tda18271_init: error -5 on line 826
[  743.284190] tda18271_tune: error -5 on line 904
[  743.284194] tda18271_set_params: error -5 on line 985
[  744.300169] tda18271_write_regs: ERROR: idx = 0x5, len = 1, i2c_transfer 
returned: -5
[  744.300180] tda18271_init: error -5 on line 826
[  744.300185] tda18271_tune: error -5 on line 904
[  744.300190] tda18271_set_params: error -5 on line 985
[  745.320172] tda18271_write_regs: ERROR: idx = 0x5, len = 1, i2c_transfer 
returned: -5
[  745.320183] tda18271_init: error -5 on line 826
[  745.320188] tda18271_tune: error -5 on line 904
[  745.320193] tda18271_set_params: error -5 on line 985
[  746.336174] tda18271_write_regs: ERROR: idx = 0x5, len = 1, i2c_transfer 
returned: -5
[  746.336185] tda18271_init: error -5 on line 826
[  746.336190] tda18271_tune: error -5 on line 904
[  746.336195] tda18271_set_params: error -5 on line 985
[  747.352170] tda18271_write_regs: ERROR: idx = 0x5, len = 1, i2c_transfer 
returned: -5
[  747.352181] tda18271_init: error -5 on line 826
[  747.352187] tda18271_tune: error -5 on line 904
[  747.352192] tda18271_set_params: error -5 on line 985
[  748.368172] tda18271_write_regs: ERROR: idx = 0x5, len = 1, i2c_transfer 
returned: -5
[  748.368183] tda18271_init: error -5 on line 826
[  748.368188] tda18271_tune: error -5 on line 904
[  748.368193] tda18271_set_params: error -5 on line 985
[  749.384179] tda18271_write_regs: ERROR: idx = 0x5, len = 1, i2c_transfer 
returned: -5
[  749.384191] tda18271_init: error -5 on line 826
[  749.384196] tda18271_tune: error -5 on line 904
[  749.384202] tda18271_set_params: error -5 on line 985
[  750.400172] tda18271_write_regs: ERROR: idx = 0x5, len = 1, i2c_transfer 
returned: -5
[  750.400182] tda18271_init: error -5 on line 826
[  750.400188] tda18271_tune: error -5 on line 904
[  750.400194] tda18271_set_params: error -5 on line 985
[  751.424170] tda18271_write_regs: ERROR: idx = 0x5, len = 1, i2c_transfer 
returned: -5
[  751.424181] tda18271_init: error -5 on line 826
[  751.424186] tda18271_tune: error -5 on line 904
[  751.424192] tda18271_set_params: error -5 on line 985
[  752.440172] tda18271_write_regs: ERROR: idx = 0x5, len = 1, i2c_transfer 
returned: -5
                                                                                                                                       
 

Any ideas?
Thanks


      
