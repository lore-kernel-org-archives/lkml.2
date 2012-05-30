Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728Ab2E3Uje (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 16:39:34 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37606 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504Ab2E3Ujd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 16:39:33 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1205281119080.26786@kaball-desktop>
References: <1337982603-15692-1-git-send-email-konrad.wilk@oracle.com>
 <1337982603-15692-2-git-send-email-konrad.wilk@oracle.com> <alpine.DEB.2.00.1205281119080.26786@kaball-desktop>
From: William Dauchy <wdauchy@gmail.com>
Date: Wed, 30 May 2012 22:39:10 +0200
Message-ID: <CAJ75kXZ6gkRF_ZwJ6va860yKT6Vh=mOeUq0YSCKO0ezxjQgqVA@mail.gmail.com>
Subject: Re: [Xen-devel] [PATCH 1/2] xen/blkback: Copy id field when doing BLKIF_DISCARD.
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "jbeulich@suse.com" <jbeulich@suse.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "stable@kernel.org" <stable@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 28, 2012 at 12:19 PM, Stefano Stabellini
<stefano.stabellini@eu.citrix.com> wrote:
>> Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=824641
>> CC: stable@kernel.org
>> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>
> Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

Tested-by: William Dauchy <wdauchy@gmail.com>

-- 
William
