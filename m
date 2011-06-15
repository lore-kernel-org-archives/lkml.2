Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879Ab1FOQFi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 12:05:38 -0400
Received: from mta11.charter.net ([216.33.127.80]:54545 "EHLO
	mta11.charter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755326Ab1FOQFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 12:05:37 -0400
X-Authority-Analysis: v=1.1 cv=vT9vkN3vVXssH3Ov7r/wQUs/sfIFjNPEFFf4aeKIi4A=
 c=1 sm=1 a=XYJHFtupD_QA:10 a=xF9yuZ1V3iQA:10 a=lDGNyK2vIvEA:10
 a=kj9zAlcOel0A:10 a=xzrYXqw+0zwiO4gHSXHcAg==:17 a=yQEvEn1JJziUU13lWOcA:9
 a=CjuIK1q_8ugA:10 a=xzrYXqw+0zwiO4gHSXHcAg==:117
Date: Wed, 15 Jun 2011 11:05:24 -0500
From: Greg Dietsche <Gregory.Dietsche@cuw.edu>
To: Julia Lawall <julia@diku.dk>
Cc: linux-kernel@vger.kernel.org, cocci@diku.dk, Gilles.Muller@lip6.fr
Subject: Re: [Cocci] Re: [PATCH v2] coccinelle: if (ret) return ret; return
 ret; semantic patch
Message-ID: <20110615160524.GA9986@farmergreg.com>
Reply-To: Greg Dietsche <Gregory.Dietsche@cuw.edu>
References: <Pine.LNX.4.64.1106060656050.7113@ask.diku.dk>
 <1307989386-17666-1-git-send-email-Gregory.Dietsche@cuw.edu>
 <Pine.LNX.4.64.1106132033460.24125@ask.diku.dk>
 <4DF67933.9080707@cuw.edu>
 <Pine.LNX.4.64.1106140746590.14970@ask.diku.dk>
 <4DF7D197.5070205@cuw.edu>
 <4DF807B4.8010807@gregd.org>
 <Pine.LNX.4.64.1106150751390.27735@ask.diku.dk>
 <4DF8D0B4.7020505@gregd.org>
 <Pine.LNX.4.64.1106151735020.10106@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1106151735020.10106@ask.diku.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 15, 2011 at 05:35:47PM +0200, Julia Lawall wrote:
> > except that 4 of the 5 ORs are cases where we want to do the -return ret; +
> > return ret; So I suppose for performance, I should actually add the +/- to
> > each of the 4 cases that we want cocci to generate a patch for?
> 
> Actually, it's probably not that big a deal.  It's only rewriting the ones 
> where there is a return ret just before, not all the returns in the code, 
> like I was originally thinking.

Ok :) I'll update the patch one last time - hopefully we've got everything nailed
down now :)

thanks for being so incredibly helpful!

Greg

> 
> julia
> 
