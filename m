Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408Ab1GAI0k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 04:26:40 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41229 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755139Ab1GAI0i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 04:26:38 -0400
Subject: Re: [PATCH v3 7/9] KVM-GST: KVM Steal time accounting
From: Peter Zijlstra <peterz@infradead.org>
To: Glauber Costa <glommer@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Avi Kivity <avi@redhat.com>, Anthony Liguori <aliguori@us.ibm.com>,
        Eric B Munson <emunson@mgebm.net>
In-Reply-To: <4E0D35E5.9080506@redhat.com>
References: <1309361388-30163-1-git-send-email-glommer@redhat.com>
	 <1309361388-30163-8-git-send-email-glommer@redhat.com>
	 <1309470872.12449.609.camel@twins>  <4E0D35E5.9080506@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 01 Jul 2011 10:25:30 +0200
Message-ID: <1309508730.12449.630.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-30 at 23:50 -0300, Glauber Costa wrote:
> I was under the impression that the proper use of jump labels required 
> each label to be tied to a single location. If we make it inline, the 
> same key would point to multiple locations, and we would have trouble
> altering all of the locations. I might be wrong, of course. Isn't it the 
> case? 

Nope, you can have as many patch sites per key as you want.
