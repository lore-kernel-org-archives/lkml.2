Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941Ab1CKGtH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 01:49:07 -0500
Received: from web31813.mail.mud.yahoo.com ([68.142.207.76]:35720 "HELO
	web31813.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752459Ab1CKGtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 01:49:04 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type;
  b=dcikE39yy/d16bM0Prg2PfFvKpi0i3iSoAc24HFaQUL4WoKIE4vqm4JRvy1/XMDden7bA8DTp7WrKc5kkkMP/XcrhVLT+imoVu/IrvhhWNOi7hYYdawdfuoLwj/4avEPhWuq/0QIJGjOSHBdPnG+gCp7sIV6SK4WBeKb7MtWUr8=;
Message-ID: <206682.3247.qm@web31813.mail.mud.yahoo.com>
X-YMail-OSG: QCcWmIsVM1ltufAjWZ0LNhRl2Fx5x.n5eu4YYf8Fy4Fpy2E
 dgESRgAPgEMuBazW8HNOGjKhDN28LD57A040CUxPMuYS6Akb8n_k_FcYXv1m
 KL787D_bh0FZc5GzSpPf6KuhvxpnMrBIucZ_JK5Vx2mU5tZYbjBCjjTS9AFY
 .kFV7lqsMDeqmwkNA0q7KFC2ueoM3l0OmmiSQlY3BVnXFLwRJHsu49UXbxDk
 phcq_uQO3N9sDoxEIRqpke5YxxTj9FAirsmyGIOE1gfa3vbJA.Omv1XcH.XO
 QWUMjb9YOLNs3RRQNpffR_xAGQDohQkRVrzWEO2SGLYqWf9PXuoymFq73Hec
 tOOp04iVysKuCDDh8ImnHb99_CgKPVlMmkzy6o_jxneeJ39keKl.W5rO87mB
 4
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.110.296531
Date: Thu, 10 Mar 2011 22:49:02 -0800 (PST)
From: Luben Tuikov <ltuikov@yahoo.com>
Reply-To: ltuikov@yahoo.com
Subject: UASP: updates and merges
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-usb@vger.kernel.org, Greg KH <greg@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The USB Attached SCSI Protocol driver (UAS, UASP) saw the following update:

[USB] UASP: TMF IU TTBM can also be reserved
    
If the TMF is not ABORT TASK and not QUERY TASK
then the TTBM field in the TMF IU shall be
reserved.

The branch can be found here off of master:
https://github.com/ltuikov/linux-2.6

Original posting of the UASP driver can be found here:
http://marc.info/?l=linux-usb&m=129165511732388&w=2

    Luben

