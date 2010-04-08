Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932892Ab0DHQTG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 12:19:06 -0400
Received: from mail-pz0-f193.google.com ([209.85.222.193]:50842 "EHLO
	mail-pz0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758771Ab0DHQTE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 12:19:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=MB8hBhgQFEivYaKrAW1ZZnAZMuzKauPSQhbnyodJiR96xSBw7Mx5c/tf5QmMnV9T/M
         e2Ji+GpQovCYkVNKYnRQp5skLbvADRgs6ojm4OSvQKj9Dg5qPzRnRruz3Nzx0rNzmUPJ
         F/TJCvBrp1NS9neiZ/0QquVI8bkvINwJMOA+I=
MIME-Version: 1.0
In-Reply-To: <20100408141423.82e04416.sfr@canb.auug.org.au>
References: <20100408131251.b69e2fa2.sfr@canb.auug.org.au>
	 <alpine.DEB.2.00.1004080452150.11948@skynet.skynet.ie>
	 <20100408141423.82e04416.sfr@canb.auug.org.au>
Date: Thu, 8 Apr 2010 09:19:01 -0700
Message-ID: <o2w12c511ca1004080919pa73e0552mec30ca706d9277a9@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the drm tree
From: Tony Luck <tony.luck@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Dave Airlie <airlied@linux.ie>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Pauli Nieminen <suokkos@gmail.com>,
       Jerome Glisse <jglisse@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Does anyone else see:

drivers/gpu/drm/ttm/ttm_page_alloc.c: In function ‘ttm_page_alloc_debugfs’:
drivers/gpu/drm/ttm/ttm_page_alloc.c:830: error: implicit declaration
of function ‘seq_printf’

when building the next-20100408 tag?

-Tony
