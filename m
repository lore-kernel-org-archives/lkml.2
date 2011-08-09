Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752376Ab1HIHWz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 03:22:55 -0400
Received: from nm28-vm4.bullet.mail.ne1.yahoo.com ([98.138.91.188]:36669 "HELO
	nm28-vm4.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751423Ab1HIHWy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 03:22:54 -0400
X-Greylist: delayed 314 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Aug 2011 03:22:54 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 185552.48096.bm@omp1055.mail.ne1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=qJSeXKbm4O674RYlQQxz1QKPeE5oTZ/rCxgrkFE5LvYxmJ2HwiLNebVPZxp6S/d91HpHqRwYxkDVa3OkTYCTbKppxECeZSAkvLJnHB2+eOtlY0307lKPBbv48xO1aqS2uMlwsOpULKjmQD9qbUIX9W0SbQABQLKYdVLKMPfzRjA=;
X-YMail-OSG: Aqt7lPEVM1kwFXRaxQp.Hg4qFt7M8m.tLuuzcaQoaGRFHOk
 mdnCjsolgbHAkd_fhVtfDODWLsydP891oJSaOMaiAjACSe8YssJxESZWnXno
 5MmAmtJKYpZMWMaqrSLaPgN7abbpQIiv5qhxWexSQa.kNTIUFJDxSRIlOo0J
 tR9lf6O7mTya39SY1i.YA279RduJ2a1zul2M6nTmdQq6FPR._RjSdUaA.fHj
 odwzdg.QdLuJ_wyFeEhtPQwO9bmPpS8gwNCppWWtjYoeau5n3uf5PkGf3dM1
 isD.H6UuhMZ73_jr3tqkFEUm2.jOXTHbaBML5nOzNmpWi67k1qwjBYpnVmai
 .wX8NUiYulRbpd1GmMGyef.1AK7DwH4KElHacglrknriHo8OHQrqKjKI7584
 iXaTK7Td9A44RmeO1mGHXiZJ9kEUbapgn4Q5lNjAvK0xm_qtGuNSggljN.SA
 7x11_
X-Mailer: YahooMailWebService/0.8.113.313619
References: <1312872786.70934.YahooMailNeo@web111712.mail.gq1.yahoo.com> <1db776d865939be598cdb80054cf5d93.squirrel@xenotime.net>
Message-ID: <1312874259.89770.YahooMailNeo@web111704.mail.gq1.yahoo.com>
Date: Tue, 9 Aug 2011 00:17:39 -0700 (PDT)
From: Mahmood Naderan <nt_mahmood@yahoo.com>
Reply-To: Mahmood Naderan <nt_mahmood@yahoo.com>
Subject: Re: running of out memory => kernel crash
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1db776d865939be598cdb80054cf5d93.squirrel@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>Do you have any kernel log panic/oops/Bug messages?
 
Actually, that happened for one my diskless nodes 10 days ago.
What I saw on the screen (not the logs), was 
"running out of memory.... kernel panic....."

I have not defined any swap partition for diskless nodes. Only the server 
has such partition. 

If you think that is an odd behavior, please let me know what will happen 
exactly when an application needs more memory but there is no room 
left and swap is disabled.
  

// Naderan *Mahmood;


----- Original Message -----
From: Randy Dunlap <rdunlap@xenotime.net>
To: Mahmood Naderan <nt_mahmood@yahoo.com>; linux-mm@kvack.org
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Sent: Tuesday, August 9, 2011 11:36 AM
Subject: Re: running of out memory => kernel crash

On Mon, August 8, 2011 11:53 pm, Mahmood Naderan wrote:
> Hi
> I have noticed that when the swap is disabled
>
> (either via swapoff or not defining any swap partition),
>
> then running out of memory can cause a kernel panic. 
>
> I wonder why the hungry application won't be killed
>
> upon a request for a resource that is not available?
> In that case, the problematic application will be killed
> only but what we see now is that the whole system is
> crashed.

Do you have any kernel log panic/oops/Bug messages?

[adding linux-mm mailing list]


-- 
~Randy
