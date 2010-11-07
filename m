Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070Ab0KGS1H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 13:27:07 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34449 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313Ab0KGS1G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 13:27:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Z9s40Z5SlwCjnIH3/tu5FKG+hVsGee3AIIz8TC6/WMTvkZus9JF66/Nj7YUDx/bI8A
         F6cgkLSAk1xQvSV7+Bpj49kcBqlszAxBn1I150gLF0FLlhNol7+q3KZXLZlZkR3QylBn
         vBYJs3Knc0Nf3FWchk5cA5e1O003mnAaiFIt8=
MIME-Version: 1.0
In-Reply-To: <20101013075346.GA24052@linux-mips.org>
References: <f3f140ca90dc9dac2f645748bc3a0150@localhost>
	<20101013075346.GA24052@linux-mips.org>
Date: Sun, 7 Nov 2010 10:27:02 -0800
Message-ID: <AANLkTinmorJRk+bEvpyQB33sUxsZ=bEWcyiGr3iWpFab@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] MIPS: HIGHMEM DMA on noncoherent MIPS32 processors
From: Kevin Cernekee <cernekee@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: dediao@cisco.com, ddaney@caviumnetworks.com, dvomlehn@cisco.com,
        sshtylyov@mvista.com, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 13, 2010 at 12:53 AM, Ralf Baechle <ralf@linux-mips.org> wrote:
> The good news is that Peter Zijlstra has rewritten kmap to make the need
> for manually allocated kmap types go away and his patches are queued to
> be merged for 2.6.37.  So I'd like to put this patch on hold until after
> his patches are merged.

v4 of this patch applies cleanly to 2.6.37-rc1 and tests OK on my hardware:

http://patchwork.linux-mips.org/patch/1695/

What do you think about queuing it for 2.6.37?
