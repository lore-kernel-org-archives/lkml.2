Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759573Ab2EIRjb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 13:39:31 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:47294 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759487Ab2EIRj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 13:39:29 -0400
MIME-Version: 1.0
In-Reply-To: <20120509173525.GO11099@arm.com>
References: <20120506160828.GE13332@sli.dy.fi>
	<20120509155519.GL11099@arm.com>
	<20120509171642.GC24636@google.com>
	<20120509173525.GO11099@arm.com>
Date: Wed, 9 May 2012 10:39:27 -0700
X-Google-Sender-Auth: rkmxdwkYjvEKgW931rNpoRBp3Ag
Message-ID: <CAOS58YMJpOhHSXacP238jkxAM7PPeApg0E4DXOMaRBnVJS5h-Q@mail.gmail.com>
Subject: Re: kmemleak: Cannot insert 0xffff880007fedd28 into the object search
 tree (already existing)
From: Tejun Heo <tj@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Sami Liedes <sami.liedes@iki.fi>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, May 9, 2012 at 10:35 AM, Catalin Marinas
<catalin.marinas@arm.com> wrote:
> I should have used git format-patch. Here it is again (if it still
> doesn't work, I'll mail it to you separately).

I already hand-applied it.  My sentence was missing "in the future". :)

Thanks.

-- 
tejun
