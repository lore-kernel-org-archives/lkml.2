Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758163Ab1FVO2l (ORCPT <rfc822;list-kernel77@spinics.net>);
	Wed, 22 Jun 2011 10:28:41 -0400
Received: from claranet-outbound-smtp06.uk.clara.net ([195.8.89.39]:36221 "EHLO
	claranet-outbound-smtp06.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758066Ab1FVO2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 10:28:40 -0400
From: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
To: "Tiberiu C. Turbureanu" <tct@ceata.org>
Subject: Re: Maximum number of inotify watches
Date: Wed, 22 Jun 2011 15:28:35 +0100
User-Agent: KMail/1.13.7 (Linux/2.6.38.6-27.fc15.x86_64; KDE/4.6.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <bbaaf72bb3386008c77db2e16112b330@ceata.org>
In-Reply-To: <bbaaf72bb3386008c77db2e16112b330@ceata.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201106221528.35648.tvrtko.ursulin@onelan.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 Jun 2011 13:59:20 Tiberiu C. Turbureanu wrote:
>  Hello,
> 
>  I want to monitor all the files on a server using one instance of
>  inotify and about 20M watches recursively set on directories in '/' tree
>  substructure. I'd want to be notified about all type of events defined
>  by inotify (create, delete, access, modify etc.)
> 
>  Assuming this monitor daemon running in user-space keeps up with the
>  frequency of new events in the kernel queue (it reads them), is it
>  possible to exceed the kernel memory limit because there are too many
>  watches and events?

It does sounds unrealistic with your number of watches. 

Have a look at fanotify which will give you a subset of inotify events for 
just one watch per mount point. If you really need events which are not 
available maybe they can be added.

Tvrtko
