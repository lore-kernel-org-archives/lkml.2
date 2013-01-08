Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754294Ab3AHBjo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 20:39:44 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:25683 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277Ab3AHBjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 20:39:42 -0500
X-AuditID: cbfee61b-b7f616d00000319b-52-50eb78ddfb0a
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>, linux-fbdev@vger.kernel.org,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Devendra Naga'" <devendra.aaru@gmail.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <000b01cdea55$92725aa0$b7570fe0$%han@samsung.com>
 <20130107160137.dec5098a.akpm@linux-foundation.org>
 <003c01cded3f$0f25a3e0$2d70eba0$%han@samsung.com>
 <20130107173557.dadc0a7a.akpm@linux-foundation.org>
In-reply-to: <20130107173557.dadc0a7a.akpm@linux-foundation.org>
Subject: Re: [PATCH] backlight: check null deference of name when device is
 registered
Date: Tue, 08 Jan 2013 10:39:40 +0900
Message-id: <004301cded41$06e0b7e0$14a227a0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3tQEhIXwseABj3STijvV2zeul/gQAAGG5g
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsVy+t8zY927Fa8DDG4uYbY40feB1eLyrjls
	DkwenzfJBTBGcdmkpOZklqUW6dslcGVM2HWMpeAeX8W3O1OZGhiXcncxcnJICJhILLw7nx3C
	FpO4cG89WxcjF4eQwDJGiatfNrPAFD1duwesSEhgEaPEqhNBEEW/GCXWN70EK2ITUJP48uUw
	UBEHh4iAvkRbiwZImFlgP6PE431OEPV3GSV+Hp7HBJLgFHCQuDfrJhuILSwQIXFhz1xGEJtF
	QFXi25w9zCA2r4CtxLmzd5kgbEGJH5PvsUAM1ZJYv/M4E4QtL7F5zVtmkL0SAuoSj/7qgoRF
	BIwkOmftZYUoEZHY9+Id1HgBiW+TD7FAlMtKbDrADHKahMA6dol1h54xQ/wrKXFwxQ2WCYwS
	s5BsnoVk8ywkm2chWbGAkWUVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRkiMSe9gXNVgcYhR
	gINRiYf3UszrACHWxLLiytxDjBIczEoivLdSgEK8KYmVValF+fFFpTmpxYcYfYAun8gsJZqc
	D4z/vJJ4Q2NjEzMTUxNzS1NzUxzCSuK8jKeeBAgJpCeWpGanphakFsGMY+LglGpgDJZ36v/2
	w8q0rPuQ15Ko+V8f9LrNLDXkP1vCG/+Z8ZN8dd0Nk5NOrIJ3YibO2Ozu8evhsVnck7YtENzp
	s3fOoavbk4vimX4+ZzgX8/nfDOGHKnMK7E70hYe83jD36q5NFUGrtriusj3F8sN/czr78wUl
	03LF0m/VrrErzGw6F9l4zef2r6C2RCWW4oxEQy3mouJEABdwjs3eAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFIsWRmVeSWpSXmKPExsVy+t9jAd07Fa8DDB7ftrI40feB1eLyrjls
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmTNh1jKXgHl/F
	tztTmRoYl3J3MXJySAiYSDxdu4cdwhaTuHBvPRuILSSwiFFi1YmgLkYuIPsXo8T6ppcsIAk2
	ATWJL18OAzVwcIgI6Eu0tWiAhJkF9jNKPN7nBFF/l1Hi5+F5TCAJTgEHiXuzboINFRaIkLiw
	Zy4jiM0ioCrxbc4eZhCbV8BW4tzZu0wQtqDEj8n3WCCGakms33mcCcKWl9i85i0zyF4JAXWJ
	R391QcIiAkYSnbP2skKUiEjse/GOcQKj0Cwkk2YhmTQLyaRZSFoWMLKsYhRNLUguKE5KzzXS
	K07MLS7NS9dLzs/dxAiO4GfSOxhXNVgcYhTgYFTi4b0U8zpAiDWxrLgy9xCjBAezkgjvrRSg
	EG9KYmVValF+fFFpTmrxIUYfoEcnMkuJJucDk0teSbyhsYmZkaWRmYWRibk5DmElcV7GU08C
	hATSE0tSs1NTC1KLYMYxcXBKNTBuy1142dPo3pcYlUZj/0frVb4zC2bfnDrllbf1ibrH3mwP
	Sp6Z7rB7N1FlTsS+pBUXg279CQiLWKCz+aecNn+WotpvpsIJKmckutyVanZ7Tng6c6/Igvzj
	f3OmfPGdNHVS2I4wvpfP125uatXZIfIx83iz/bOULZ8ir22QnVH4xmqlvHymnbS4EktxRqKh
	FnNRcSIA6SEI6A0DAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 08, 2013 10:36 AM, Andrew Morton wrote
> On Tue, 08 Jan 2013 10:25:35 +0900 Jingoo Han <jg1.han@samsung.com> wrote:
> 
> > On Tuesday, January 08, 2013 9:02 AM, Andrew Morton wrote
> > > On Fri, 04 Jan 2013 17:29:11 +0900
> > > Jingoo Han <jg1.han@samsung.com> wrote:
> > >
> > > > NULL deference of name is checked when device is registered.
> > > > If the name is null, it will cause a kernel oops in dev_set_name().
> > > >
> > > > ...
> > > >
> > > > --- a/drivers/video/backlight/backlight.c
> > > > +++ b/drivers/video/backlight/backlight.c
> > > > @@ -292,6 +292,11 @@ struct backlight_device *backlight_device_register(const char *name,
> > > >  	struct backlight_device *new_bd;
> > > >  	int rc;
> > > >
> > > > +	if (name == NULL) {
> > > > +		pr_err("backlight name is null\n");
> > > > +		return ERR_PTR(-EINVAL);
> > > > +	}
> > > > +
> > > >  	pr_debug("backlight_device_register: name=%s\n", name);
> > >
> > > I don't understand this.
> > >
> > > Is there some driver which is calling these functions with name=NULL?
> > > If so, which one(s)?
> >
> > No, there is no one.
> >
> > >
> > > If "no" then why don't we declare that "passing name=NULL is a bug" and
> > > leave the code as-is?
> >
> > Do you mean following?
> >
> > +	if (name == NULL)
> > +		pr_err("passing name=NULL is a bug");
> > +
> >   	pr_debug("backlight_device_register: name=%s\n", name);
> 
> Nope; I'm suggesting we leave the code alone.  If someone passes in
> NULL they will get a nice oops and their bug will then get fixed.

I see. I agree with you.
Please, abandon this patch.

Best regards,
Jingoo Han

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fbdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

