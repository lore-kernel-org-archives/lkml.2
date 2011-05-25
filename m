Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757841Ab1EYNxt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 09:53:49 -0400
Received: from cantor.suse.de ([195.135.220.2]:55604 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757253Ab1EYNxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 09:53:48 -0400
Date: Wed, 25 May 2011 15:53:46 +0200
From: Michal Marek <mmarek@suse.cz>
To: Arun Sharma <asharma@fb.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] kbuild: Move firmware images to a separate RPM
Message-ID: <20110525135346.GH2276@sepie.suse.cz>
References: <1305653779-3445-1-git-send-email-asharma@fb.com>
 <1305653779-3445-4-git-send-email-asharma@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305653779-3445-4-git-send-email-asharma@fb.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 17, 2011 at 10:36:17AM -0700, Arun Sharma wrote:
> +echo 'make %{?_smp_mflags} INSTALL_FW_PATH=$RPM_BUILD_ROOT/lib/firmware KBUILD_SRC= firmware_install'

I don't think we need firmware_install, just package the firmware
installed by modules_install.

Michal
