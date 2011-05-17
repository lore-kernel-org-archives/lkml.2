Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018Ab1EQRqU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 13:46:20 -0400
Received: from outmail021.snc4.facebook.com ([66.220.144.153]:57305 "EHLO
	mx-out.facebook.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755756Ab1EQRqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 13:46:19 -0400
Date: Tue, 17 May 2011 10:46:18 -0700
From: Arun Sharma <asharma@fb.com>
To: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] kbuild: Append RPM release to $KERNELRELEASE
Message-ID: <20110517174618.GA4647@dev1756.snc6.facebook.com>
References: <1305653779-3445-1-git-send-email-asharma@fb.com>
 <1305653779-3445-5-git-send-email-asharma@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305653779-3445-5-git-send-email-asharma@fb.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 17, 2011 at 10:36:18AM -0700, Arun Sharma wrote:
> Provide the same consistency as distributor kernels.
> uname -r matches RPM name (includes the release)

Not all of the patches in this series may be appropriate for
inclusion into kbuild. But I wanted to send them out anyway
to get feedback on how things can be improved.

This patch in particular changes the rpm name and might need
to be an opt-in feature.

 -Arun
