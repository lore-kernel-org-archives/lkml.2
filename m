Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866Ab1AYQ1V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 11:27:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40062 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751251Ab1AYQ1T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 11:27:19 -0500
Date: Tue, 25 Jan 2011 11:26:54 -0500
From: Dave Jones <davej@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, lenb@kernel.org, linux-acpi@vger.kernel.org,
        cpufreq@vger.kernel.org
Subject: Re: [PATCHSET] workqueue: update workqueue users - replace
 create_workqueue()
Message-ID: <20110125162654.GA4795@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Tejun Heo <tj@kernel.org>,
	linux-kernel@vger.kernel.org, lenb@kernel.org,
	linux-acpi@vger.kernel.org, cpufreq@vger.kernel.org
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
 <20110125142921.GB27510@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110125142921.GB27510@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 03:29:21PM +0100, Tejun Heo wrote:
 > Hello,
 > 
 > There was no response for the following patches and I'm planning on
 > routing them through workqueue#for-2.6.39.  If you have an objection
 > or want to take the patch through a different tree, please let me
 > know.
 > ..
 >  0007-cpufreq-use-system_wq-instead-of-dedicated-workqueue.patch

Feel free to add my 
Signed-off-by: Dave Jones <davej@redhat.com> 
to this.

I looked it over, and didn't see anything objectionable.

	Dave
