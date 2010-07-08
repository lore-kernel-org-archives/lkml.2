Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758531Ab0GHTb0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 15:31:26 -0400
Received: from n1c.bullet.mail.ac4.yahoo.com ([76.13.13.78]:45181 "HELO
	n1c.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758507Ab0GHTbZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 15:31:25 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 847599.49770.bm@omp126.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=GI7RyaMj0yHkgkC+vytl/6PeQ6Prdu+xMtloMP0QTWr19ehTgi+07drbfNY8SCbo/OqzZBxRJaqexnIh/ly51y5zryUjrxdj7Jna7jLWCQFW/7RXjEtUlRZmf6y4Wb+gmCgTTZC6B+7Wb92C5aS4kslC1hcqK8cOw7itu94Ftoc=;
Message-ID: <752897.66667.qm@web180316.mail.gq1.yahoo.com>
X-YMail-OSG: qXqNiMIVM1l_AWFTZYZCSTGHTn9qSVR5p2itpAPE5S_L_cs
 C6pCoI3Ei6LSMd8KgixAvsB_JnjjyaAhYKjfcPc6i9yK1cSyZA0gD.kQHuT5
 pqiY3P8inUfQEQ_Ubg2NSWBhwn4nx9bkN0hyJrYQ_O6aWtxHATg8aPW8El1t
 mU_dSua8GEH32.k8duYQcqRKbJmfITlcPeqzbsK5xiCx6gV8yUMlnV0yKAr2
 VFU3vPNGSH.nHjnDzz0wMeECrcqVtXYp9ZMp9F6orY7r96qris82cpDLkI5K
 rXfR2_gwxdwSNK9x6oobnpyqemAwSv7eJqe3symkvpPx59GdcQ79HqUI-
X-Mailer: YahooMailClassic/11.2.4 YahooMailWebService/0.8.104.274457
Date: Thu, 8 Jul 2010 12:31:23 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCHv2 1/2] USB: gadget: mass/file storage: set serial number
To: Greg KH <greg@kroah.com>,
       =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Cc: linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org,
       Dries Van Puymbroeck <Dries.VanPuymbroeck@dekimo.com>,
       stable <stable@kernel.org>
In-Reply-To: <op.vfjga9ie7p4s8u@pikus>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> >> This commit adds iSerialNumber to all gadgets that
> use the Mass Storage Function.

Can it be made to do so only when the gadget
hasn't been provided with one already?  Serial
number module options are standard parts of the
composite gadget framework...


