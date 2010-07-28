Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897Ab0G1RQH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 13:16:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12363 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755745Ab0G1RQF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 13:16:05 -0400
Date: Wed, 28 Jul 2010 13:53:11 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Nested SVM fix and next_rip emulation
Message-ID: <20100728165311.GA27124@amt.cnet>
References: <1280247261-19115-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280247261-19115-1-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 27, 2010 at 06:14:19PM +0200, Joerg Roedel wrote:
> Hi Avi, Marcelo,
> 
> here are two small patches for kvm-amd. The first patch fixes a small bug in
> nested svm efer handling. The second patch implements emulation for the
> next_rip feature.

Applied, thanks.

