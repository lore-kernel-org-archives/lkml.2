Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753Ab1EQWam (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 18:30:42 -0400
Received: from dsl-67-204-24-19.acanac.net ([67.204.24.19]:42865 "EHLO
	mail.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756647Ab1EQWam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 18:30:42 -0400
Date: Tue, 17 May 2011 18:30:22 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: Borislav Petkov <bp@amd64.org>
Cc: =?iso-8859-1?Q?J=F6rg-Volker?= Peetz <jvpeetz@web.de>,
        Boris Ostrovsky <boris.ostrovsky@amd.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Greg Kroah-Hartman <greg@kroah.com>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>, X86-ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 0/2] AMD ARAT fixes
Message-ID: <20110517223022.GA21342@elliptictech.com>
References: <1305636919-31165-1-git-send-email-bp@amd64.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1305636919-31165-1-git-send-email-bp@amd64.org>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-05-17 14:55 +0200, Borislav Petkov wrote:
> Although the patches look almost trivial, I'd like to ask Nick and
> Jörg-Volker to test them, please, so that we can have a confirmation,
> just in case.

Works as advertised, both patches applied on top of 2.6.38.6.

Thanks,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
