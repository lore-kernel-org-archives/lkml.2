Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276Ab0FPNHS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 09:07:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53799 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143Ab0FPNHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 09:07:16 -0400
Date: Wed, 16 Jun 2010 10:07:03 -0300
From: Glauber Costa <glommer@redhat.com>
To: Zachary Amsden <zamsden@redhat.com>
Cc: avi@redhat.com, mtosatti@redhat.com, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/17] Eliminate duplicated timer code
Message-ID: <20100616130703.GH19104@mothafucka.localdomain>
References: <1276587259-32319-1-git-send-email-zamsden@redhat.com>
 <1276587259-32319-2-git-send-email-zamsden@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276587259-32319-2-git-send-email-zamsden@redhat.com>
X-ChuckNorris: True
User-Agent: Jack Bauer
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 14, 2010 at 09:34:03PM -1000, Zachary Amsden wrote:
> Move duplicated timer related code into arch_vcpu_load rather
> than vendor callouts.  Should be an isomorphic transformation.
> 
> Signed-off-by: Zachary Amsden <zamsden@redhat.com>
Acked-by: Glauber Costa <glommer@redhat.com>

