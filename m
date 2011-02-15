Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353Ab1BOP1R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 10:27:17 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:60383 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754097Ab1BOP1O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 10:27:14 -0500
Subject: Re: [PATCH v3 3/6] KVM-GST: KVM Steal time accounting
From: Peter Zijlstra <peterz@infradead.org>
To: Avi Kivity <avi@redhat.com>
Cc: Glauber Costa <glommer@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
In-Reply-To: <4D5A9909.90305@redhat.com>
References: <1297448364-14051-1-git-send-email-glommer@redhat.com>
	 <1297448364-14051-4-git-send-email-glommer@redhat.com>
	 <4D5A8F28.4090306@redhat.com> <1297781155.2413.16.camel@twins>
	 <4D5A9909.90305@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 15 Feb 2011 16:27:07 +0100
Message-ID: <1297783627.2413.24.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-15 at 17:17 +0200, Avi Kivity wrote:
> 
> Ah, so we're all set.  Do you know if any user tools process this 
> information? 

I suppose there are, I bet Jeremy knows, Xen after all supports this
stuff ;-)
