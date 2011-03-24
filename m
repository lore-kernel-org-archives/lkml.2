Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933430Ab1CXHcc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 03:32:32 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36321 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933363Ab1CXHca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 03:32:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=OkIvBdEBOCE0QBn3wnFm5MA+fnoWjlq7+yF4RB6+7lv/gGk9w3CpOTEyqQSM/NbP+y
         ZqTT2Me1jgCCzHLMv6DmDxUqNNx9neY8YIG1AgH9+GbwNQMzkWFeJ9faMNToL43CX+cu
         JVVFUa3DNyfOJMOwM+GRCK2OFQz0Ra/OC2ULI=
Date: Thu, 24 Mar 2011 09:32:25 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Daniel Reichelt <debian@nachtgeist.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: procfs: boot- and runtime configurable access mode for
 /proc/<pid> dirs
Message-ID: <20110324073225.GA3806@p183.telecom.by>
References: <4D8AC408.9000503@nachtgeist.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D8AC408.9000503@nachtgeist.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 05:09:44AM +0100, Daniel Reichelt wrote:
> the attached patch enhances the procfs code to allow for modification of
> /proc/<pid> dir access modes. It does so
> - by hard-wiring (.config) a boot-time default mode (555, 550 or 500)
> - which can be overriden by a boot parameter piddir_mode
> - and also introduces an inode /proc/piddirs (644) which enables
> runtime-configuration (already existing pid-dirs will be updated on next
> access)

> Let me know what you think and please CC me on replying.

Keeping u/g/o inside kernel is horrible.

What is the usecase? Content of /proc/* is identical.
