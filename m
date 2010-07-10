Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752978Ab0GJVcV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 17:32:21 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38689 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852Ab0GJVcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 17:32:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=Dlb3PQbSriN8M558rPfDqT154FMivluXJtCOqpY2Vm78frtgl7e7m6nBegnljnkcxj
         DhsTniCasY73zBGdiHGxj7bTbTBgah7X+aS6fnHfwZtPT7G7+JhZD6nYRoOOSeHaSgcY
         29Ssco5P7g4RV6yOtMeY+UDhhZxKeQz9DUSTU=
Date: Sun, 11 Jul 2010 01:32:11 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH v2] x86: Early-boot serial I/O support
Message-ID: <20100710213211.GD6615@lenovo>
References: <1278790820-1817-1-git-send-email-penberg@cs.helsinki.fi> <20100710210750.GC6615@lenovo> <AANLkTim1wgrOaz5rXV-Cea3IjcZejrsRrCO0AUkcrOv-@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTim1wgrOaz5rXV-Cea3IjcZejrsRrCO0AUkcrOv-@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 11, 2010 at 12:18:06AM +0300, Pekka Enberg wrote:
> On Sun, Jul 11, 2010 at 12:07 AM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> >> @@ -203,6 +205,17 @@ static inline int isdigit(int ch)
> >>       return (ch >= '0') && (ch <= '9');
> >>  }
> >>
> >> +static inline int isxdigit(int ch)
> >> +{
> >> +     if (isdigit(ch))
> >> +             return true;
> >> +
> >> +     if ((ch >= 'a') && (ch <= 'f'))
> >> +             return true;
> >> +
> >> +     return (ch >= 'A') && (ch <= 'F');
> >> +}
> >> +
> >
> > I suspect it's supposed to be static inline *bool*, right?
> 
> Yes, but I followed 'isdigit' here for symmetry and it uses 'int'.
> 
>                        Pekka
> 

ok, I see

	-- Cyrill
