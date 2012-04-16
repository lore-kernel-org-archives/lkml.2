Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884Ab2DPX6P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 19:58:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24611 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810Ab2DPX6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 19:58:13 -0400
X-Authority-Analysis: v=2.0 cv=IaEFqBWa c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=s3nvyBDuQC4A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=0azM3ZO7AAAA:8 a=68eEZQRoAAAA:8 a=fUl8lY1HmGEe7czQXw4A:9 a=PUjeQqilurYA:10 a=BGWj8ct6lkoA:10 a=7YLhZ6jOsBkA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1334620691.28106.12.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] [Trivial] ktest: change singular "paranthesis" to
 plural "parantheses"
From: Steven Rostedt <rostedt@goodmis.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Jesper Juhl <jj@chaosbits.net>, linux-kernel@vger.kernel.org,
        trivial@kernel.org
Date: Mon, 16 Apr 2012 19:58:11 -0400
In-Reply-To: <4F8CD243.30900@xenotime.net>
References: <alpine.LNX.2.00.1204170027250.21898@swampdragon.chaosbits.net>
	 <4F8CCFFF.2060808@xenotime.net>
	 <alpine.LNX.2.00.1204170110460.21898@swampdragon.chaosbits.net>
	 <4F8CD243.30900@xenotime.net>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-16 at 19:15 -0700, Randy Dunlap wrote:
> On 04/16/2012 04:12 PM, Jesper Juhl wrote:
> 
> > On Mon, 16 Apr 2012, Randy Dunlap wrote:
> > 
> >> On 04/16/2012 03:28 PM, Jesper Juhl wrote:
> >>
> >>> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> >>> ---
> >>>  tools/testing/ktest/sample.conf |    2 +-
> >>>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> It's misspelled before and after the patch.  :(
> >>
> > Ahh, crap, you are right. Sorry about that :-(
> > 
> > I could try to blame that on english not being my first language, but I 
> > won't since it's just me screwing up.
> > I did read the patch several times before sending it and thought I'd made 
> > sure there were no trivial errors like that, but I was wrong - damn it.
> > 
> > 
> > This should be better :
> > 
> > From: Jesper Juhl <jj@chaosbits.net>
> > Date: Mon, 16 Apr 2012 19:40:24 +0200
> > Subject: [PATCH] [Trivial] ktest: change singular "paranthesis" to plural "parentheses"
> > 
> 
> 
> Looks good.  Thanks.
> 
> Acked-by: Randy Dunlap <rdunlap@xenotime.net>
> 

I'll pull this into my queue for 3.5

-- Steve


