Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233Ab1G0Ns5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 09:48:57 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:52451 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879Ab1G0Nsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 09:48:55 -0400
MIME-Version: 1.0
In-Reply-To: <20110727130604.GD6713@dumpdata.com>
References: <cover.1311736366.git.luto@mit.edu> <b6598d164fbe64eeea37c0369b64dd6ceaeeb504.1311736366.git.luto@mit.edu>
 <20110727130604.GD6713@dumpdata.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Wed, 27 Jul 2011 09:48:35 -0400
X-Google-Sender-Auth: pXMezpNOpovKJgFJj9wbndLHCf4
Message-ID: <CAObL_7G7ddd1NEWY_GNbt8kNRE+dbHC6A=sMLFV00q2AackuXw@mail.gmail.com>
Subject: Re: [PATCH 4/5] x86-64/xen: Enable the vvar mapping
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: x86@kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        jeremy@goop.org, keir.xen@gmail.com, xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 27, 2011 at 9:06 AM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
> On Tue, Jul 26, 2011 at 11:20:38PM -0400, Andy Lutomirski wrote:
>> Xen needs special treatment for fixmaps.
>
> The description needs a bit more, for example:
>
> "Xen needs to handle the newly introduced VVAR_PAGE introduced by
> git commit 9fd67b4ed0714ab718f1f9bd14c344af336a6df7
> "x86-64: Give vvars their own page"

Will do.

--Andy
