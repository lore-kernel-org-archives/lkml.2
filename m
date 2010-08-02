Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654Ab0HBOab (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 10:30:31 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53309 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085Ab0HBOaa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 10:30:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bMxbn4MWdfYkW6r6gdLS/+ZMt2tF+Re39eoAFnNzd9irwteUmocak5/qy/Z3MuL9Zf
         oqw5MSpnM1hzWk8Z80vDw6zUxLlC3P/syA7DzEr8oQ3RqirUwbgN74m+QmjU45OZ38Ik
         SpQM02DWad+R0LegmBFrORMrsyhiNPeIxNnBg=
MIME-Version: 1.0
In-Reply-To: <1280751836-1826-1-git-send-email-dfeng@redhat.com>
References: <20100729130707.GA31154@shamino.rdu.redhat.com>
	<1280751836-1826-1-git-send-email-dfeng@redhat.com>
Date: Mon, 2 Aug 2010 16:30:28 +0200
Message-ID: <AANLkTimk=LXAv_AS62y3a41_irkRzpwWUCeo5So7AzAh@mail.gmail.com>
Subject: Re: [RFC PATCH V2] core_pattern: fix long parameters was truncated by 
	core_pattern handler
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Xiaotian Feng <dfeng@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Roland McGrath <roland@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +                               rc = snprintf(NULL, 0, "%s", current->comm);

rc = strlen(current->comm) would be smaller

-- 
vda
