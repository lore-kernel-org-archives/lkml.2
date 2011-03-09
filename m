Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102Ab1CIHlp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 02:41:45 -0500
Received: from web31816.mail.mud.yahoo.com ([68.142.206.169]:26595 "HELO
	web31816.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752296Ab1CIHln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 02:41:43 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type;
  b=pucsPOWZy6Ytzu5+sqJjd6IRGI/TLY590dByM2tzAOAUEdYD60oCLxmNNWAPsaZGumEx31cxvDa2zN1dEeeD/FKLSYlLgLYAWoZ3bS/U68+4CWhR2gzPBQBpKcXEDQ7M7uh+yUYny2WcGm0vOGkwbNU825UpUAGcTfESR9MUNpo=;
Message-ID: <794860.74593.qm@web31816.mail.mud.yahoo.com>
X-YMail-OSG: GypUMmMVM1lINVyzyA1_G4BX3HQY.CbxIXvMrdTSZpiWIGe
 fMmRiL5qVtocA9gv.C.bZidvvlN2UFslnNjD7iqGpd8bxyWqwdnGwqjHdZoM
 9Z9aJYDTPIC0o1Hrwtuhb44M2CCE1NWl9hf0cG9pNWgbhmt2WLiVcwRzEqiV
 WvovN6W5ettDGxHcholD0xo2u2atAp5ZpAt4WqERk6B92moGjLnViq_UB7n1
 qdwqw.rZZE5YayEBVhvspJ9Ueqb3iYQ6g6NG85OGt1g_nqX8Hm9nDd.o_x5Z
 046JGynAjHvfzfXOhiT_w9mY0mUbTdcKzuW0kZ2n7sZdTzWbk.aJbCVPuDLC
 HwOhcKEvS2fcReOQ2vg--
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.110.296531
Date: Tue, 8 Mar 2011 23:35:00 -0800 (PST)
From: Luben Tuikov <ltuikov@yahoo.com>
Reply-To: ltuikov@yahoo.com
Subject: UASP: updates and merges
To: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-scsi@vger.kernel.org, Greg KH <greg@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've merged Linux 2.6.38-rc8. The UASP driver saw the following update:

[USB] UASP: Process INVALID INFORMATION UNIT response

A UAS Target Port responds with a RESPONSE IU with
RESPONSE CODE set to INVALID INFORMATION UNIT,
when it receives an IU with IU ID set to a
reserved value.  Handle this response.

The branch can be found here off of master:
https://github.com/ltuikov/linux-2.6

Original posting of the UASP driver can be found here:
http://marc.info/?l=linux-usb&m=129165511732388&w=2

    Luben

