Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659Ab1BAKwy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 05:52:54 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:65170 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754633Ab1BAKww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 05:52:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=veIkiXMa8clo54q0iu8zNAajZTIRNxRE3acUjoKBY0TzW1k+KzLbuqC48gv4rELW53
         1ylVa0UweWM/8EB28o74fkFKNWxscI89qKjLtAyrZkpoVsBR90QopHIOsBgXzMSA4X+X
         6VJef+UMoUTpImM19fMOtImNW4fciWg1RcDKk=
Date: Tue, 1 Feb 2011 11:52:46 +0100
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org
Subject: Re: [PATCH 15/32] wireless/libertas[_tf]: use system_wq instead of
 dedicated workqueues
Message-ID: <20110201105246.GK14211@htj.dyndns.org>
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
 <1294062595-30097-16-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294062595-30097-16-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 03, 2011 at 02:49:38PM +0100, Tejun Heo wrote:
> With cmwq, there's no reason to use separate workqueues in
> libertas[_tf] drivers.  Drop them and use system_wq instead.  All used
> work items are sync flushed/canceled on driver detach.
> 
> Cc: Dan Williams <dcbw@redhat.com>
> Cc: libertas-dev@lists.infradead.org
> ---
> Only compile tested.  Please feel free to take it into the subsystem
> tree or simply ack - I'll route it through the wq tree.

Dan, ping?

-- 
tejun
