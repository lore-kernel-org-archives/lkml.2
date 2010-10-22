Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759641Ab0JVVN4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 17:13:56 -0400
Received: from web31810.mail.mud.yahoo.com ([68.142.207.73]:37994 "HELO
	web31810.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755783Ab0JVVNz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 17:13:55 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=moL11rhdeyr2MHgcSzWYWCmizDcaY/+RA4+uBVAsJ/TpKRYkBsPQjGqvM0zw0sDTowMXjnx/bV5qhqDQXl8ek0lodbCpvnwrgxjOioEM43aMl0ZFiNUWfW+4NeZbQDulczOEtrcbVGmrCafPeGUhmAqZ9wxX2jtR2PV0hBOAaA4=;
Message-ID: <177615.57592.qm@web31810.mail.mud.yahoo.com>
X-YMail-OSG: PB95XyYVM1lbvKGiUnVOLz_b8ENLwvyk1aGlum8yBGY46xP
 U7gRNlBUklBtk0nc4jGIt15hqjKin55fqDIoiUFevDr1KIWw4bocmboQPDrm
 fORsULLXS_k0SJZZ3WqiE1oT_Qokj_T7ZNdYGSyEgekuOIHyQ0QU3cMiKMFB
 AnIMFylPgdan1NpvBiaOHLoU98FsUf_VrnEza995Ymw8bDzV3QfEo1DkJNB0
 aca6rhQB8F8EVB4lBFDDuvcRID7QG7fTKhbGJHf8xpNzlIf2oQMTBbiwTyPW
 iQzSTtXVcISvL55GNfo5KTcJuhEHzU0EqJhOLAkq7xTvaQbMKSBRxInBbd8F
 kGG9h6m4JBA--
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.107.285259
Date: Fri, 22 Oct 2010 14:13:53 -0700 (PDT)
From: Luben Tuikov <ltuikov@yahoo.com>
Reply-To: ltuikov@yahoo.com
Subject: Re: [PATCH] [USB] Use normalized sense when emulating autosense
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.44L0.1010221029430.1529-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Fri, 10/22/10, Alan Stern <stern@rowland.harvard.edu> wrote:
> What about the Filemark and ILI tests?  You mustn't
> get rid of them; 
> they are needed for tape drives.

I've resubmitted the patch.

