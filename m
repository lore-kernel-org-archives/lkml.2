Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426Ab0DGUcO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 16:32:14 -0400
Received: from web50105.mail.re2.yahoo.com ([206.190.38.33]:45205 "HELO
	web50105.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751798Ab0DGUcM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 16:32:12 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Apr 2010 16:32:12 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=qcTPe7n3Bmp9QlAtjycSbaRjlctcKUHRML5QTxnU1UQwML4Pk+xhrhwudlJpY7joVAs8ajS1c+Wm6FQWhFpQJmK8OpAywlTJuz5uUCOkYCRJfWAdQHz1C+LH1en1aq0yKdbQ4WyKjqzz32AHFDKq1TWmx0OAyqoSMEH1/VHpybw=;
Message-ID: <513313.86867.qm@web50105.mail.re2.yahoo.com>
X-YMail-OSG: Oq4CeHAVM1n6646H5Ye66oUvI7E485A5irC9qErViRiW8ai
 MSzbFKo6zY0SbMklY0_ZAkFEHd9vkRiBiZgJwlKMzs9B4_Z5cAHgc0P0IVFx
 dEQs7UPzKvqPCyz_mzZ9Qe2lhB6RZA9GpYDRvvtJsGNpsVxnEUNKp577fBtV
 3aiv1mFOiFLrhQi_8LB2ward8Vcx77J3_ncX7GdbIxbRl3SXmGoV6JH4xHUZ
 wIULN1bb7XL._FvxKUTI48wQWlJwM1KfGaYkrHF.pwGOY_pEIzpw4zurNdTJ
 5r9kLNx46PQUEY8FLV3nvHVCK7p.A257KkHvH7eeVAKVHqBIAhyzUe8Hq21A
 KutWAFAHX9VjEsQ.D_1vzBQzGuxI-
X-Mailer: YahooMailClassic/10.1.8 YahooMailWebService/0.8.100.260964
Date: Wed, 7 Apr 2010 13:25:31 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Subject: Re: [PATCH 07/11] drivers/edac/e7*_edac.c: Rename dev_info to edi
To: Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>
Cc: Mark Gross <mark.gross@intel.com>,
       Doug Thompson <dougthompson@xmission.com>,
       bluesmoke-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <cde34c3008ca9ecae613c966a62845413518542c.1270493677.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Mon, 4/5/10, Joe Perches <joe@perches.com> wrote:

> From: Joe Perches <joe@perches.com>
> Subject: [PATCH 07/11] drivers/edac/e7*_edac.c: Rename dev_info to edi
> To: "Andrew Morton" <akpm@linux-foundation.org>
> Cc: "Mark Gross" <mark.gross@intel.com>, "Doug Thompson" <dougthompson@xmission.com>, bluesmoke-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
> Date: Monday, April 5, 2010, 1:05 PM
> There is a macro called dev_info that
> prints struct device specific
> information.  Having variables with the same name can
> be confusing and
> prevents conversion of the macro to a function.
> 
> Rename the existing dev_info variables to something else in
> preparation
> to converting the dev_info macro to a function.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: Doug Thompson <dougthompson@xmission.com>


