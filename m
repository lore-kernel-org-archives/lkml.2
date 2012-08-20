Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581Ab2HTHa2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 03:30:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61837 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755292Ab2HTHa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 03:30:26 -0400
Subject: Re: [PATCH] Extcon: Minor change in the declaration of cable_names
From: anish kumar <anish198519851985@gmail.com>
To: myungjoo.ham@samsung.com
Cc: =?UTF-8?Q?=EC=B5=9C=EC=B0=AC=EC=9A=B0?= <cw00.choi@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>
In-Reply-To: <28057486.209671345445798709.JavaMail.weblogic@epml13>
References: <28057486.209671345445798709.JavaMail.weblogic@epml13>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 20 Aug 2012 12:57:15 +0530
Message-ID: <1345447635.1568.1.camel@anish-Inspiron-N5050>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-08-20 at 06:56 +0000, 함명주 wrote:
> > From: anish kumar <anish198519851985@gmail.com>
> > 
> > Instead of "const char **supported_cable" it is better to have
> > it as "const char *const *supported_cable".
> > 
> > Signed-off-by: anish kumar <anish198519851985@gmail.com>
> 
> Could you please elaborate on why it's better?
> 
> (Is this fixing the using the standard naming issue Mark mentioned before?)
No, It is what Lars(Lars-Peter Clausen) mentioned when he was doing the
review earlier.It is nothing but a general practise as cable_names is
constant. 
> 
> 
> Cheers!
> MyungJoo
> 
> > ---
> >  include/linux/extcon.h                 |    2 +-
> >  include/linux/extcon/extcon-adc-jack.h |    2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/include/linux/extcon.h b/include/linux/extcon.h
> > index cdd4014..a6bcc29 100644
> > --- a/include/linux/extcon.h
> > +++ b/include/linux/extcon.h
> > @@ -111,7 +111,7 @@ struct extcon_cable;
> >  struct extcon_dev {
> >  	/* --- Optional user initializing data --- */
> >  	const char	*name;
> > -	const char **supported_cable;
> > +	const char *const *supported_cable;
> >  	const u32	*mutually_exclusive;
> >  
> >  	/* --- Optional callbacks to override class functions --- */
> > diff --git a/include/linux/extcon/extcon-adc-jack.h b/include/linux/extcon/extcon-adc-jack.h
> > index 20e9eef..f27f2e8 100644
> > --- a/include/linux/extcon/extcon-adc-jack.h
> > +++ b/include/linux/extcon/extcon-adc-jack.h
> > @@ -60,7 +60,7 @@ struct adc_jack_pdata {
> >  	/*
> >  	 * The last entry should be NULL
> >  	 */
> > -	const char **cable_names;
> > +	const char *const *cable_names;
> >  	/* The last entry's state should be 0 */
> >  	struct adc_jack_cond *adc_conditions;
> >  
> > -- 
> > 1.7.1
> > 
> > 
> > 
> > 
> >        
> >   
> >          
> > 


