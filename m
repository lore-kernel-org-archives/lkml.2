Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932380Ab2EVUD5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 16:03:57 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52638 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932317Ab2EVUDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 16:03:55 -0400
MIME-Version: 1.0
In-Reply-To: <1337644682-19854-2-git-send-email-suresh.b.siddha@intel.com>
References: <1337643880.1997.166.camel@sbsiddha-desk.sc.intel.com>
	<1337644682-19854-1-git-send-email-suresh.b.siddha@intel.com>
	<1337644682-19854-2-git-send-email-suresh.b.siddha@intel.com>
Date: Tue, 22 May 2012 13:03:55 -0700
X-Google-Sender-Auth: FZQatz36NyM-CNk2u9_6dZ5GTqI
Message-ID: <CAE9FiQW5FJt_YR5p4B19K2-mj6gwk82zxB9DbVMfBicjXr_VpQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] x2apic, cluster: use all the members of one cluster
 specified in the smp_affinity mask for the interrupt desintation
From: Yinghai Lu <yinghai@kernel.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: agordeev@redhat.com, linux-kernel@vger.kernel.org, x86@kernel.org,
        gorcunov@openvz.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 4:58 PM, Suresh Siddha
<suresh.b.siddha@intel.com> wrote:
> We are now grouping all the cpu's in a cluster to one vector domain. So that
> will limit the total number of interrupt sources handled by Linux. Previously
> we support "cpu-count * available-vectors-per-cpu" interrupt sources but this
> will now reduce to "cpu-count/16 * available-vectors-per-cpu".

maybe could add some boot parameter to control cpu number in same
domain that is used instead of 16.

Thanks

Yinghai
