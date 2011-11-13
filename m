Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983Ab1KMMt4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 07:49:56 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33728 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681Ab1KMMty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 07:49:54 -0500
MIME-Version: 1.0
In-Reply-To: <1321143760.20271.31.camel@x61.thuisdomein>
References: <1321143760.20271.31.camel@x61.thuisdomein>
Date: Sun, 13 Nov 2011 07:49:52 -0500
Message-ID: <CA+5PVA79SP3HvDqOx1Tducggnh=s3arA4JOdWSgMbY_9SveSNg@mail.gmail.com>
Subject: Re: [PATCH] [TRIVIAL] powerpc/4xx: Fix typo 'PCC4xx_MSI'
From: Josh Boyer <jwboyer@gmail.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Jiri Kosina <trivial@kernel.org>, Rupjyoti Sarmah <rsarmah@amcc.com>,
        Tirumala R Marri <tmarri@apm.com>,
        Josh Boyer <jwboyer@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 12, 2011 at 7:22 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> 0) This corrects an obvious typo. It is untested.
>
> 1) This could influence the code generated for the "AMCC PPC440SPe
> evaluation board". So I've CC'd the people involved in commit 3fb7933850
> ("powerpc/4xx: Adding PCIe MSI support"), which introduced this typo, to
> actually test this.

My linux.vnet.ibm.com address should be bouncing by now.  Anyway,
patch looks good.

Acked-by: Josh Boyer <jwboyer@gmail.com>

josh
