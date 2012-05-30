Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752325Ab2E3Kcf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 06:32:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:43140 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146Ab2E3Kce convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 06:32:34 -0400
Message-ID: <1338373947.26856.240.camel@twins>
Subject: Re: [PATCH v3 2/6] account guest time per-cgroup as well.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, devel@openvz.org,
        Paul Turner <pjt@google.com>, Tejun Heo <tj@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>, handai.szj@gmail.com,
        Andrew.Phillips@lmax.com, Serge Hallyn <serge.hallyn@canonical.com>
Date: Wed, 30 May 2012 12:32:27 +0200
In-Reply-To: <1338371317-5980-3-git-send-email-glommer@parallels.com>
References: <1338371317-5980-1-git-send-email-glommer@parallels.com>
	 <1338371317-5980-3-git-send-email-glommer@parallels.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-30 at 13:48 +0400, Glauber Costa wrote:
> We already track multiple tick statistics per-cgroup, using
> the task_group_account_field facility. This patch accounts
> guest_time in that manner as well.

So this leaves IOWAIT and IDLE the only fields not using
task_group_account_field(), right?
