Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471Ab1EKQSu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:18:50 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58782 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757184Ab1EKQSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:18:48 -0400
Subject: Re: [PATCH 1/3] perf, core: Introduce attrs to count in either
 host or guest mode
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Avi Kivity <avi@redhat.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
In-Reply-To: <4DCA76D7.2010608@redhat.com>
References: <1305038132-5080-1-git-send-email-joerg.roedel@amd.com>
	 <1305038132-5080-2-git-send-email-joerg.roedel@amd.com>
	 <4DCA76A5.7030000@redhat.com>  <4DCA76D7.2010608@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 May 2011 15:49:05 +0200
Message-ID: <1305121745.2914.216.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-11 at 14:45 +0300, Avi Kivity wrote:
> Well, actually, that depends on the meaning of exclude_hv.

exclude_hv is for when the host is a guest and we don't wish to sample
the host's host etc. PPC introduced this because ppc-linux runs as a
guest of the 'firmware' and not on the native hardware.

