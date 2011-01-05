Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576Ab1AERjB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 12:39:01 -0500
Received: from canuck.infradead.org ([134.117.69.58]:37518 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243Ab1AERi6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 12:38:58 -0500
Subject: Re: [RFC -v3 PATCH 2/3] sched: add yield_to function
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Avi Kivity <avi@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Rik van Riel <riel@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>
In-Reply-To: <4D24ABD7.4040503@redhat.com>
References: <20110103162637.29f23c40@annuminas.surriel.com>
	 <20110103162918.577a9620@annuminas.surriel.com>
	 <1294164289.2016.186.camel@laptop>  <4D24A5F4.3000508@redhat.com>
	 <1294247718.2016.269.camel@laptop>  <4D24A822.4000009@redhat.com>
	 <1294248511.2016.274.camel@laptop>  <4D24ABD7.4040503@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 05 Jan 2011 18:39:19 +0100
Message-ID: <1294249159.2016.275.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-05 at 19:35 +0200, Avi Kivity wrote:

> Tejun, why did you end up not using preempt_notifiers in cmwq?

Because I told him to use explicit function calls because that keeps the
code easier to read.



