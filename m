Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099Ab2JIPIN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 11:08:13 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:56781 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410Ab2JIPIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 11:08:11 -0400
Message-ID: <50743DD7.9050207@gmail.com>
Date: Tue, 09 Oct 2012 09:08:07 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: acme@ghostprotocols.net, peterz@infradead.org
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3 v3] perf: precise mode and exclude_guest
References: <1347569955-54626-1-git-send-email-dsahern@gmail.com>
In-Reply-To: <1347569955-54626-1-git-send-email-dsahern@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/13/12 2:59 PM, David Ahern wrote:
> Hopefully this wraps up the precise mode-exclude_guest dependency.
> I'm sure someone will let me know if I screwed up the attribution
> in the second patch.
>
> David Ahern (2):
>    perf tool: precise mode requires exclude_guest
>    perf tool: give user better message if precise is not supported
>
> Peter Zijlstra (1):
>    perf: require exclude_guest to use PEBS - kernel side enforcement
>
> v3: removed extra tab in patch 2
> v2: updated commit messages for patches 1 and 2

Any chance this get committed? At the least userspace code? It has been 
3 months since I first reported the problem and what appears to be an 
acceptable solution has been lingering for a month.

David
