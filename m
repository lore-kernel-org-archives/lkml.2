Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752279Ab1JIVDR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Oct 2011 17:03:17 -0400
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:39310 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537Ab1JIVDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Oct 2011 17:03:15 -0400
Subject: Re: [PATCH 10/16] perf stat: Allow tab as cvs delimiter
From: Paul Bolle <pebolle@tiscali.nl>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Jim Cromie <jim.cromie@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
In-Reply-To: <1317336490-19437-11-git-send-email-acme@infradead.org>
References: <1317336490-19437-1-git-send-email-acme@infradead.org>
	 <1317336490-19437-11-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 09 Oct 2011 22:58:06 +0200
Message-ID: <1318193886.1903.34.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-29 at 19:48 -0300, Arnaldo Carvalho de Melo wrote:
> From: Jim Cromie <jim.cromie@gmail.com>
> 
> If option -x '\t' is given, convert '\t' to "\t".  This makes cvs
> printing more flexible.

I found this message when I searched my mail for occurences of 'cvs'. Is
it still possible to change 'cvs' to 'csv' in the commit summary and
message? That would keep the result for grepping of either term (in
commit summaries or messages) correct.


Paul Bolle

