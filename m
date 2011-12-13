Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862Ab1LMOse (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 09:48:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15003 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751940Ab1LMOsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 09:48:33 -0500
Date: Tue, 13 Dec 2011 09:48:27 -0500
From: Jason Baron <jbaron@redhat.com>
To: Greg KH <greg@kroah.com>
Cc: jim.cromie@gmail.com, joe@perches.com, bart.vanassche@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 00/24 ] dynamic debug enhancements: multi-queries during
 mod-init
Message-ID: <20111213144826.GA2529@redhat.com>
References: <CAJfuBxyyriN6vYgwzEft9PKFjWsa2E4FZmbFMmtO6G_DP=nosg@mail.gmail.com>
 <CAJfuBxzM6rg21Rpq+ww+=2qK_am44V-Btvhp3Z3hbP2TKP8JTw@mail.gmail.com>
 <1323198694-7186-1-git-send-email-jim.cromie@gmail.com>
 <20111212220537.GB1641@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111212220537.GB1641@kroah.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 02:05:37PM -0800, Greg KH wrote:
> Jason, I'm going to wait for you to test these and forward them on to me
> if you really want me to apply any of them.
> 
> greg k-h

Hi Greg,

Ok, I'm going to test the latest series today. The ability to pass a
module param to turn on dynamic debug is a feature I've been asked about
a lot - so I think its an important ehancement.

Thanks,

-Jason
