Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751416Ab1AXIil (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 03:38:41 -0500
Received: from smtp-out.google.com ([74.125.121.67]:16527 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330Ab1AXIij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 03:38:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=WjGLue1m7q6Ig+1nGXnY8XmkBq1mDijMasJmnsnFtgk0TMoDtHqp8oaWiEKKy1Xa1E
         j3CV+9C7GsItPs8Icz9w==
MIME-Version: 1.0
In-Reply-To: <20101226120951.GB28529@ghc17.ghc.andrew.cmu.edu>
References: <20101224082226.GA13872@ghc17.ghc.andrew.cmu.edu>
 <20101226120919.GA28529@ghc17.ghc.andrew.cmu.edu> <20101226120951.GB28529@ghc17.ghc.andrew.cmu.edu>
From: Paul Menage <menage@google.com>
Date: Mon, 24 Jan 2011 00:38:15 -0800
Message-ID: <AANLkTimkxP6r5sqZJTnFRzAZMq1mC8miss_hBS6kh6Kf@mail.gmail.com>
Subject: Re: [PATCH v7 1/3] cgroups: read-write lock CLONE_THREAD forking per threadgroup
To: Ben Blum <bblum@andrew.cmu.edu>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        akpm@linux-foundation.org, ebiederm@xmission.com, lizf@cn.fujitsu.com,
        matthltc@us.ibm.com, oleg@redhat.com,
        David Rientjes <rientjes@google.com>, Miao Xie <miaox@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 26, 2010 at 4:09 AM, Ben Blum <bblum@andrew.cmu.edu> wrote:
> (...please include patches inline...)

Reviewed-by: Paul Menage <menage@google.com>

Thanks,
Paul
