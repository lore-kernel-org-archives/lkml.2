Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758641Ab1F1PXX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 11:23:23 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52119 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758544Ab1F1PWX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 11:22:23 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTikRULUhVne2ZfLJp6eBmxrS2bumqQ@mail.gmail.com>
References: <1309244992-2305-1-git-send-email-jim.cromie@gmail.com>
 <1309244992-2305-5-git-send-email-jim.cromie@gmail.com> <BANLkTikRULUhVne2ZfLJp6eBmxrS2bumqQ@mail.gmail.com>
From: Jim Cromie <jim.cromie@gmail.com>
Date: Tue, 28 Jun 2011 09:21:53 -0600
Message-ID: <BANLkTi=tVk=QRhWs_QA-XytEwJ9cV2J46g@mail.gmail.com>
Subject: Re: [PATCH 04/11] dynamic_debug: warn when >1 of each type of
 match-spec is given
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-kernel@vger.kernel.org, gnb@fmeh.org, jbaron@redhat.com,
        gregkh@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 28, 2011 at 4:17 AM, Bart Van Assche <bvanassche@acm.org> wrote:
> On Tue, Jun 28, 2011 at 9:09 AM, Jim Cromie <jim.cromie@gmail.com> wrote:
>> -                       query->format = unescape(words[i+1]);
>> +                       check_set(&query->format, words[i+1], "format");
>
> Was it your intention to remove the call to "unescape" ?
>
> Bart.
>

No, that was accidental. thanks for pointing it out.
