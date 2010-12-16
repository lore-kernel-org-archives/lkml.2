Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893Ab0LPJkK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 04:40:10 -0500
Received: from web31804.mail.mud.yahoo.com ([68.142.207.67]:30109 "HELO
	web31804.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751256Ab0LPJkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 04:40:08 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type;
  b=F240+9aiR1Otzd6TqOqO8o1UXJ75jwEIoAShi0YxrxMZ4j7BxPx+GVR7EfB82B+xoJdD2gEk7Kg9K81WuB4qnUaBNfhX26t+Xl3BzYoxVLTLZNrvbXLtwy11YdDaolnaQk1I7ZI4EhZMcY0gM9rqkIoXbYwmmWbgl4C1t0Ly/Ks=;
Message-ID: <178171.36505.qm@web31804.mail.mud.yahoo.com>
X-YMail-OSG: CbLPkvQVM1mHl8Tu8JvtzIEfTOKI.LuwKOvMjKV5AlXOxFr
 iGpnE5rrfb9KxU..eYrAnLfeqGHbAdDhjbUp3NNT2FqolUTCfKMWw6vnco4m
 rzurXH8vNy_1LEYWjfdGDB30_UQEZVyYuhTGOQbINRRcVpSqGuaySIskwbJh
 NyIPZ8.Cx76n75rFaQ23WBBHsICkfTLd3B1VqaDsM_GfjgzzshBs.qN8sBV.
 RjRu69meg_981PdzQw1g5aLbgbkM6iwLf0eapYkVsqHTiKquk.aNLBzZ9zjl
 hUabaNuZxVM6pRAobQ.CKu0mCyiJ.bxqv0bqKsB0BF5VTSAn2alVsZlZBiDW
 5SfwDD0k2FoWZzUtYrB0_Du5IDmFgHdZfhespN2nlpj9qNIE57aDaSqLTYbK
 j_EhzVVpMhosfRw--
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.107.289296
Date: Thu, 16 Dec 2010 01:40:07 -0800 (PST)
From: Luben Tuikov <ltuikov@yahoo.com>
Reply-To: ltuikov@yahoo.com
Subject: Re: [ANNOUNCE] UAS uasp.c driver available on github
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-usb@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Mon, 12/13/10, Luben Tuikov <ltuikov@yahoo.com> wrote:
> The uasp.c driver is available on
> github at https://github.com/ltuikov/linux-2.6. The
> free-linux branch is a branch off of the master branch. The
> free-linux branch contains the following:
> 
>  * uasp.c driver which allows you to connect to USB
> Attached SCSI (UAS) devices and use them as SCSI devices.
> 
> The free-linux branch also includes the following patches:
> 
>  * 6e5eba [USB] Use normalized sense when emulating
> autosense,
>  * 245423 [SCSI] Retrieve the Caching mode page, and
>  * 67869f [BLOCK] Preliminary increasing tag sequence
> implementation.
> 
> The first two of those patches, 6e5eba and 245423, have
> been accepted into topic branches and should be merged in
> the next (or current) kernel release.
> 
> The 67869f patch is needed to eliminate TMF processing race
> conditions in case of multiple application clients issuing
> commands to the same I_T nexus as I described here: http://marc.info/?t=128902350400001&r=1&w=2.

A read-only git URL where you could pull from would be: git://github.com/ltuikov/linux-2.6.git

   Luben

