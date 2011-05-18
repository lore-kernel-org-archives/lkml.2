Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932950Ab1ERLcy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 07:32:54 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51967 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932873Ab1ERLcx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 07:32:53 -0400
Subject: Re: [PATCH v1 5/5] KVM: Expose a version 1 architectural PMU to
 guests
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
In-Reply-To: <20110518110759.GB16556@elte.hu>
References: <1305129333-7456-1-git-send-email-avi@redhat.com>
	 <1305129333-7456-6-git-send-email-avi@redhat.com>
	 <20110517194117.GA26184@elte.hu> <4DD38B57.2070904@redhat.com>
	 <20110518110759.GB16556@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 18 May 2011 13:32:30 +0200
Message-ID: <1305718350.2466.7110.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-18 at 13:07 +0200, Ingo Molnar wrote:
> 
> It does through raw events - which are indeed model specific.

Which is exactly what is needed anyway, he gets a raw msr value.

The only thing that is not exposed is the ANY bit, but since KVM doesn't
expose HT anyway that doesn't matter.
