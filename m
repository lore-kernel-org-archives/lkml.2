Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757618Ab0JRScs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 14:32:48 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:35176 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754954Ab0JRSci convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 14:32:38 -0400
Date: Mon, 18 Oct 2010 14:32:23 -0200
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Mike Frysinger <vapier@gentoo.org>, linux-bluetooth@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        steven miao <realmz6@gmail.com>
Subject: Re: [PATCH] bluetooth: fix unaligned access to l2cap conf data
Message-ID: <20101018163223.GC2468@vigoh>
References: <1287268187-9628-1-git-send-email-vapier@gentoo.org>
 <AANLkTinMSbhTkH0zQn_YO7hFF7zkuv-Gj-B0BUFWy5nP@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <AANLkTinMSbhTkH0zQn_YO7hFF7zkuv-Gj-B0BUFWy5nP@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Harvey,

* Harvey Harrison <harvey.harrison@gmail.com> [2010-10-18 11:17:28 -0700]:

> On Sat, Oct 16, 2010 at 3:29 PM, Mike Frysinger <vapier@gentoo.org> wrote:
> > From: steven miao <realmz6@gmail.com>
> >
> >
> >        case 2:
> > -               *((__le16 *) opt->val) = cpu_to_le16(val);
> > +               put_unaligned_le16(cpu_to_le16(val), opt->val);
> >                break;
> >
> 
> I think you wanted:
> put_unaligned_le16(val, opt->val);

I fixed that in the tree. Thanks for the report. 

-- 
Gustavo F. Padovan
ProFUSION embedded systems - http://profusion.mobi
