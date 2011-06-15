Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046Ab1FOQGl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 12:06:41 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:65471 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755022Ab1FOQGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 12:06:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=JVzEp9hgH99WAy8kOQkgakrDEZwsT1jKlAEsBe6ruUM9UP+76voGCEkI0T3b5RqtD5
         Y4tuYARUI3JObXnQDS+xUV7QB5Q/OBYB+awTRPrv4vyU0PqZeD7R18c2/t8f8x+hec+G
         2joP+VyXRhlyInwYPmat7dBKRv2yQ+Ev7NDp4=
MIME-Version: 1.0
In-Reply-To: <E1QWsJ4-0008Fh-ER@eag09.americas.sgi.com>
References: <E1QWsJ4-0008Fh-ER@eag09.americas.sgi.com>
Date: Wed, 15 Jun 2011 19:06:11 +0300
X-Google-Sender-Auth: 90wvH41GIqi_EcdqAOESTGyu7Pc
Message-ID: <BANLkTimOJpexCfGPbBGGF6CdSRAntyK+DA@mail.gmail.com>
Subject: Re: [PATCH 2/8 v2] x86, UV: inline header file functions
From: Pekka Enberg <penberg@kernel.org>
To: Cliff Wickman <cpw@sgi.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 15, 2011 at 6:47 PM, Cliff Wickman <cpw@sgi.com> wrote:
> From: Cliff Wickman <cpw@sgi.com>
>
> Make all the functions in uv_bau.h inline so that it can
> be included in the fake prom (used in simulations).
> Otherwise they will generate warnings for unused functions.
>
> Diffed against 3.0.0-rc3
>
> Signed-off-by: Cliff Wickman <cpw@sgi.com>

Reviewed-by: Pekka Enberg <penberg@kernel.org>
