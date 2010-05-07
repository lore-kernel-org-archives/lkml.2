Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757108Ab0EGQbp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 12:31:45 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34084 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756890Ab0EGQbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 12:31:44 -0400
Message-ID: <4BE440AD.20300@colorfullife.com>
Date: Fri, 07 May 2010 18:32:45 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Oren Laadan <orenl@cs.columbia.edu>
CC: Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Serge Hallyn <serue@us.ibm.com>, Matt Helsley <matthltc@us.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v21 053/100] c/r (ipc): allow allocation of a desired
 ipc identifier
References: <1272723382-19470-1-git-send-email-orenl@cs.columbia.edu> <1272723382-19470-54-git-send-email-orenl@cs.columbia.edu>
In-Reply-To: <1272723382-19470-54-git-send-email-orenl@cs.columbia.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oren,


On 05/01/2010 04:15 PM, Oren Laadan wrote:
> @@ -82,7 +82,7 @@ void shm_init_ns(struct ipc_namespace *ns)
>    * Called with shm_ids.rw_mutex (writer) and the shp structure locked.
>    * Only shm_ids.rw_mutex remains locked on exit.
>    */
> -static void do_shm_rmid(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp)
> +void do_shm_rmid(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp)
>   {
>   	struct shmid_kernel *shp;
>   	shp = container_of(ipcp, struct shmid_kernel, shm_perm);
>    
This hunk appears to be unrelated to the main patch.
Is it intentional or a left-over from debugging?

--
     Manfred
