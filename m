Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582Ab1BIOVi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 09:21:38 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36401 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755260Ab1BIOVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 09:21:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Awb1NThjxtIthKQHqZEWRULm378nlh9duewvZ9BW0qcJvES3dKL00stAd7dwG8HElu
         mVsD7n5gzvTmky0BhqM5QIJj7o1FeCU4FHWsWMZupZRj3wdEhCyYyUUEiwr9vHn1DC6d
         wA5o4/ygobjP/a3wf5txe3ToQb6p9Wiyq7PeA=
Date: Wed, 9 Feb 2011 15:21:32 +0100
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after
 PTRACE_ATTACH
Message-ID: <20110209142132.GI3770@htj.dyndns.org>
References: <20110204130455.GA3671@redhat.com>
 <20110204144858.GI12133@htj.dyndns.org>
 <20110204170602.GB15301@redhat.com>
 <20110205133926.GM12133@htj.dyndns.org>
 <20110207134235.GB22538@redhat.com>
 <20110207141135.GA16992@htj.dyndns.org>
 <20110207153723.GA27997@redhat.com>
 <20110207163121.GB16992@htj.dyndns.org>
 <20110207174821.GA1237@redhat.com>
 <20110209141803.GH3770@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110209141803.GH3770@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 09, 2011 at 03:18:03PM +0100, Tejun Heo wrote:
> Heh, I'm asking for proof that it is more useful. :-) But I'm still
          ^
         not
:-)

-- 
tejun
