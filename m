Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441Ab0I2Qst (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 12:48:49 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56850 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596Ab0I2Qsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 12:48:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=qRRzrKr/3UMYwsR1lwWxTOt6wXp2LbItu9L3M8cOIW5AedOsP3he855zstk1voV+mO
         490RaQvxRkRC0jbEmzM/c+0bi0+QDrlE/AtM02W08lrN6eMZVaSyJmZL/cseSgZaRh4R
         TjvbEeCdapRGhVCVR0UX5MSboQkQNQjNBvdyU=
Subject: Re: null dereference in ipip6_get_stats in linux-next
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jesse Gross <jesse@nicira.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <AANLkTin2E2ACB5yiAUA7MbYqzYyMKAi+syFOCzXWqVrY@mail.gmail.com>
References: <20100929162625.GB17087@fieldses.org>
	 <AANLkTin2E2ACB5yiAUA7MbYqzYyMKAi+syFOCzXWqVrY@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 29 Sep 2010 18:48:35 +0200
Message-ID: <1285778915.2813.163.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 29 septembre 2010 à 09:39 -0700, Jesse Gross a écrit :
> On Wed, Sep 29, 2010 at 9:26 AM, J. Bruce Fields <bfields@fieldses.org> wrote:
> > Last night's linux-next fails to boot for me; apologies if this is already
> > known.
> 
> Eric sent out a patch for this:
> http://patchwork.ozlabs.org/patch/65961/

Also same kind of problem for ipip :

 http://patchwork.ozlabs.org/patch/65951/

Sorry guys :(




