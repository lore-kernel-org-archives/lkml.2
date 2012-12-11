Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872Ab2LKO5m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 09:57:42 -0500
Received: from unicorn.mansr.com ([78.86.181.103]:48529 "EHLO
	unicorn.mansr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030Ab2LKO5l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 09:57:41 -0500
X-Greylist: delayed 460 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Dec 2012 09:57:41 EST
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
To: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>, Pekka Enberg <penberg@kernel.org>,
        glommer@parallels.com, js1304@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: signed size_t ?
References: <50c71402.BHvgqw/3pK2m2gAL%fengguang.wu@intel.com>
	<0000013b8a5f57c0-442ea272-5d51-4870-af48-ed948a98b2ef-000000@email.amazonses.com>
Date: Tue, 11 Dec 2012 14:49:59 +0000
In-Reply-To: <0000013b8a5f57c0-442ea272-5d51-4870-af48-ed948a98b2ef-000000@email.amazonses.com>
	(Christoph Lameter's message of "Tue, 11 Dec 2012 14:30:02 +0000")
Message-ID: <yw1xhans63u0.fsf@unicorn.mansr.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter <cl@linux.com> writes:

> On Tue, 11 Dec 2012, kbuild test robot wrote:
>
>> mm/slab_common.c: In function 'create_boot_cache':
>> mm/slab_common.c:219:6: warning: format '%zd' expects argument of type 'signed size_t', but argument 3 has type 'size_t' [-Wformat]
>
> We already changed that once from %td to %zd so that the size_t works
> correctly.

If the argument is correctly of type size_t, the format should be '%zu'
since size_t is unsigned.

> Does a signed size_t make any sense?

A signed type corresponding to size_t sometimes makes sense and it's
called ssize_t.

-- 
Måns Rullgård
mans@mansr.com
