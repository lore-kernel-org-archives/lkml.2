Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868Ab1HaVPk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 17:15:40 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33775 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755823Ab1HaVPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 17:15:36 -0400
Date: Wed, 31 Aug 2011 23:15:32 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Daniel Ehrenberg <dehrenberg@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, Christoph Hellwig <hch@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: Approaches to making io_submit not block
Message-ID: <20110831211532.GA7761@one.firstfloor.org>
References: <CAAK6Zt2icmsBxjdqFvDXfnxZHXuKN3hDSTdDmh7Vhj1iJ_5LXQ@mail.gmail.com> <20110830053231.GA1627@infradead.org> <CAAK6Zt2P3jBPfeCPioK-ehpVAw0iQjikY0BujXfQmfozJ8GNvA@mail.gmail.com> <20110831052627.GA5338@infradead.org> <m2pqjlo6e5.fsf@firstfloor.org> <CAAK6Zt1nknjUe+U1yUwQVF_sZ1x1B-p7GtLFUrALCWDLbqvTGw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAK6Zt1nknjUe+U1yUwQVF_sZ1x1B-p7GtLFUrALCWDLbqvTGw@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This objection would seem to point to the benefits of doing something
> like Suparna's patches, with a wait queue per task, no? This preserves
> the current regime where each thread calling io_submit ends up
> submitting things in parallel.

Yep, Suparna's code didn't have that problem.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
