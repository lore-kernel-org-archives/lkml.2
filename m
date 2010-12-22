Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042Ab0LVLD0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 06:03:26 -0500
Received: from mail-ey0-f171.google.com ([209.85.215.171]:33541 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab0LVLDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 06:03:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=eIFOw+/QiU8JeLQ5cNuGuKsIrkCHiGmpFwP9h5ay8dDl7Z9JruQrgErFr1Z1wMotI1
         7hq25sgnn1f/UVrFMpe6GWPbOyV2t7LAn6z4bwSeUv6sQak9sgFGC3edxJ+Pr/sEOEH4
         kTMsbmCcUs/mcSza9F+9IEAX/EHmS64+q8LzM=
Date: Wed, 22 Dec 2010 14:03:18 +0300
From: Vasiliy Kulikov <segoon@openwall.com>
To: Solar Designer <solar@openwall.com>
Cc: Colin Walters <walters@verbum.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pavel Kankovsky <peak@argo.troja.mff.cuni.cz>
Subject: Re: [RFC] ipv4: add ICMP socket kind
Message-ID: <20101222110318.GA6224@albatros>
References: <20101221181800.GA8166@albatros>
 <AANLkTikS6rs-AFGmtTfuRdELJ5+y=o4g1i0Xk9KDFRiv@mail.gmail.com>
 <20101221194606.GA25359@openwall.com>
 <AANLkTin6_fck1SbCbX5tLvY8CPzJstqmpkJuVF-B6oC6@mail.gmail.com>
 <20101221213212.GA26006@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101221213212.GA26006@openwall.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 22, 2010 at 00:32 +0300, Solar Designer wrote:
> We use OpenVZ containers
> heavily, and we don't want to run an instance of such process per
> container (up to a few hundred per system).

Besides memory usage daemons cannot allocate reliably unique icmp echo
identifiers as they don't know anything about already assigned idents.


Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
