Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757141Ab0JYQIL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 12:08:11 -0400
Received: from web37608.mail.mud.yahoo.com ([209.191.87.91]:30029 "HELO
	web37608.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757039Ab0JYQIK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 12:08:10 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=BKuCHKVIZlTZMDZ1l/Ff5DrYhhTR65FHGoaOLp/LesGoH7+uMtb5IxrAVH/ah2sZg1PstAka0tP13ZJKsXXHtO2yfJbjHMxkNBy2hCeqIOs47PPN7ppjOsHuLF/j8bjdG7Fb2P1xf0ZAOVZyIi+HVSoMb22+Irq/OSFgWmw01B4=;
Message-ID: <87141.68777.qm@web37608.mail.mud.yahoo.com>
X-YMail-OSG: yGToq3gVM1m.FM25N5sTJ7.sCJXnT1AEmihl_uXQkHPTwrd
 YFBw7j0pKBqcc3D6.N..kAnrmuMszjd5ykXvDchKPB_1b8uojdUFTfJN9xij
 m9_k0GhSPIWgGjfMreL6ZFaNbLhDW8or_huNTZKvCzolBsY2D6zFsNxLU0er
 qo9NTWzv5.nq1eYt1gcJeFWBBGBl4lfROyz5EILQsdb9ziA_X51p0CT27ITd
 8_EvqqG1aZdT9Jgp4t1gNn_H1LviE4e1DPwSNZxMU0Lbfc341f5zwa8pBNu7
 sDm7cC6UdfKi0PAsB2Z9nO8osrMBHMisqt87XawntTCnBNkXYbBSr9vt8iL.
 p3dKPCs6eKph3IoLxi6kgXSKbzlCDq0Gp4.jYHuC33IftRpk6
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.107.284920
Date: Mon, 25 Oct 2010 09:08:08 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH 21/29] memstick: jmb38x_ms: rework TPC execution
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>
In-Reply-To: <1287791637-10329-22-git-send-email-maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Fri, 22/10/10, Maxim Levitsky <maximlevitsky@gmail.com> wrote:

> From: Maxim Levitsky <maximlevitsky@gmail.com>
> Subject: [PATCH 21/29] memstick: jmb38x_ms: rework TPC execution
> To: "Alex Dubov" <oakad@yahoo.com>
> Cc: "Andrew Morton" <akpm@linux-foundation.org>, "LKML" <linux-kernel@vger.kernel.org>, "Maxim Levitsky" <maximlevitsky@gmail.com>
> Received: Friday, 22 October, 2010, 4:53 PM
> Code rewritten to make it simplier.
> A lot of debug output is added to help
> diagnose bugs.
> 
> No major functional changes
> 
> Signed-off-by: Maxim Levitsky<maximlevitsky@gmail.com>

Was not broken beforehand.



      
