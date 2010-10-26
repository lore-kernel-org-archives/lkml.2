Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757661Ab0JZCNL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 22:13:11 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59311 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159Ab0JZCNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 22:13:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ba5t/Dnf6DMymoXE7aSZvQlDif6qHSyXiBUKD3qBd1djZ35TNfRcSw5ErZDTkNKYIE
         PH3vug47itURCIHa91pz5FvXwfOVHbh4bD4kWSEHoqhIaL8WvOZ/HPDFeU2RnBXLN/BL
         36wmSfsfLS0sMvreMZaHoamm03OUPNaCZM+Ho=
Subject: Re: [PATCH 16/29] memstick: jmb38x_ms: s/jmb38x_ms/j38ms/g
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <502046.56920.qm@web37604.mail.mud.yahoo.com>
References: <502046.56920.qm@web37604.mail.mud.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Oct 2010 04:13:04 +0200
Message-ID: <1288059184.4024.148.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-25 at 08:58 -0700, Alex Dubov wrote:
> 
> --- On Fri, 22/10/10, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> 
> > From: Maxim Levitsky <maximlevitsky@gmail.com>
> > Subject: [PATCH 16/29] memstick: jmb38x_ms: s/jmb38x_ms/j38ms/g
> > To: "Alex Dubov" <oakad@yahoo.com>
> > Cc: "Andrew Morton" <akpm@linux-foundation.org>, "LKML" <linux-kernel@vger.kernel.org>, "Maxim Levitsky" <maximlevitsky@gmail.com>
> > Received: Friday, 22 October, 2010, 4:53 PM
> > This just makes it easier to type
> > function names
> > while still keeping the meaning
> > Driver name and filenames are left unchanged.
> > 
> > 
> > Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
> > ---
> 
> What sort of patch/argument is this?
> Function prefix should match the module name, to be immediately and
> unambiguously identifiable in the stack trace.
In that case maybe rename the module too?
'jmb38x_ms' is just a mouthful as Andrew Morton would say.

I mean if you really really dislike that, I could revert it, but for
peoples sake, whats wrong with that?

Best regards,
	Maxim Levitsky

