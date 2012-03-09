Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528Ab2CIGxs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 01:53:48 -0500
Received: from csamuel.org ([74.50.50.137]:50323 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752455Ab2CIGxr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 01:53:47 -0500
X-Greylist: delayed 601 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Mar 2012 01:53:47 EST
Message-ID: <4F59A69E.1040002@csamuel.org>
Date: Fri, 09 Mar 2012 17:43:42 +1100
From: Chris Samuel <chris@csamuel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: kernel BUG at fs/btrfs/delayed-inode.c:1466!
References: <CADDYkjQHvmfhmsdt7K0O74DZK6BVqxPaWh_jEi8uJ_HBEz-QhQ@mail.gmail.com>	<20120308155211.GF4334@twin.jikos.cz> <CADDYkjTG-q5+pFRFt9sGKq=cgL=ZgQaNZV=2ipBsSbuvxCa3jw@mail.gmail.com> <4F595D6D.6080809@cn.fujitsu.com>
In-Reply-To: <4F595D6D.6080809@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/12 12:31, Liu Bo wrote:

> So are these warnings based on the latest upstream of btrfs?

Looks like it was 3.2.7, his oops said:

Pid: 1488, comm: mips-wrs-linux- Tainted: G        W    3.2.7 #2 HP

-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC
