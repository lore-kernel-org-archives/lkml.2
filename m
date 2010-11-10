Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614Ab0KJSQv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 13:16:51 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50960 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379Ab0KJSQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 13:16:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hRm4RIGn8ngt9D0dS8y9RyYsUIYAPv841v0+2jgCyteZ1rpe5AcTeFw8nkk5uNWnNj
         YZHZaruL2pcGnelnL9s9gXH/tpTBFPSeCEe8B2scqt0u/kyFw0SYkMKE+poW54uOyMnG
         6KIHsSFRmBaSRJb2LIg5Wm/c2zUMYz18vn7yc=
Date: Wed, 10 Nov 2010 21:16:42 +0300
From: Vasiliy Kulikov <segooon@gmail.com>
To: walter harms <wharms@bfs.de>
Cc: kernel-janitors@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jpirko@redhat.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] net: packet: fix information leak to userland
Message-ID: <20101110181641.GA11499@albatros>
References: <1288545028-16436-1-git-send-email-segooon@gmail.com>
 <4CCE84E2.9050801@bfs.de>
 <20101106143911.GA17428@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101106143911.GA17428@albatros>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,

Are there any other suggestions about this patch?


Thanks,

-- 
Vasiliy
