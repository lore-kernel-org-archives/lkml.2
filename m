Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590Ab1CJOqK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 09:46:10 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47267 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324Ab1CJOqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 09:46:07 -0500
Message-ID: <4D78E3EB.8080207@librato.com>
Date: Thu, 10 Mar 2011 09:44:59 -0500
From: Mike Heffner <mike@librato.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100908 Remi/fc12 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Eric B Munson <emunson@mgebm.net>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, rdunlap@xenotime.net,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH] Documentation: cgroups: Add notes on removing PIDs from
 tasks and cgroups requiring setup
References: <1299704969-4485-1-git-send-email-emunson@mgebm.net> <AANLkTinW99M1FBp5gRA=+SsjUWSJBwByurqrsjXKgQ4=@mail.gmail.com>
In-Reply-To: <AANLkTinW99M1FBp5gRA=+SsjUWSJBwByurqrsjXKgQ4=@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/2011 06:13 PM, Paul Menage wrote:
> On Wed, Mar 9, 2011 at 1:09 PM, Eric B Munson<emunson@mgebm.net>  wrote:
>>
>> +Note: To remove a task from a cgroup you must write its PID to the root
>> +tasks file.
>> +
>
> This isn't really accurate - the root cgroup is a cgroup like all the
> others. More accurate would be something like:
>
> Since every task is always a member of exactly one cgroup in each
> mounted hierarchy, to remove a task from its current cgroup you must
> move it into a new cgroup (possibly the root cgroup) by writing to the
> new cgroup's tasks file.


If we are updating this documentation, can we include a blurb that 
mentions if the 'ns' cgroup is mounted in the hierarchy, moving a 
process to a new cgroup can fail?


Mike

