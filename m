Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757969Ab2AKSCP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 13:02:15 -0500
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:39194 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756976Ab2AKSCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 13:02:10 -0500
Message-ID: <4F0DDC3F.80804@xenotime.net>
Date: Wed, 11 Jan 2012 11:00:15 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: "Justin P. Mattock" <justinmattock@gmail.com>
CC: trivial@kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH]drivers:staging:android Typos: fix some comments that
 have typos in them.
References: <1326294589-4872-1-git-send-email-justinmattock@gmail.com>
In-Reply-To: <1326294589-4872-1-git-send-email-justinmattock@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2012 07:09 AM, Justin P. Mattock wrote:
> From: "Justin P. Mattock" <justinmattock@gmail.com>
> 
> Below is a patch that fixes some typos in some comments.
> 
> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> ---
>  drivers/staging/android/TODO     |    2 +-
>  drivers/staging/android/binder.c |    2 +-
>  drivers/staging/android/pmem.c   |   10 +++++-----
>  3 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/staging/android/TODO b/drivers/staging/android/TODO
> index e59c5be..b15fb0d 100644
> --- a/drivers/staging/android/TODO
> +++ b/drivers/staging/android/TODO
> @@ -3,7 +3,7 @@ TODO:
>  	- sparse fixes
>  	- rename files to be not so "generic"
>  	- make sure things build as modules properly
> -	- add proper arch dependancies as needed
> +	- add proper arch dependencies as needed
>  	- audit userspace interfaces to make sure they are sane
>  
>  Please send patches to Greg Kroah-Hartman <greg@kroah.com> and Cc:
> diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
> index 7491801..d3a95fe 100644
> --- a/drivers/staging/android/binder.c
> +++ b/drivers/staging/android/binder.c
> @@ -257,7 +257,7 @@ struct binder_ref {
>  };
>  
>  struct binder_buffer {
> -	struct list_head entry; /* free and allocated entries by addesss */

	                                                         address */

> +	struct list_head entry; /* free and allocated entries by addess */
>  	struct rb_node rb_node; /* free entry by size or allocated entry */
>  				/* by address */
>  	unsigned free:1;
> diff --git a/drivers/staging/android/pmem.c b/drivers/staging/android/pmem.c
> index 7d97032..07fbe07 100644
> --- a/drivers/staging/android/pmem.c
> +++ b/drivers/staging/android/pmem.c
> @@ -34,7 +34,7 @@
>  
>  #define PMEM_DEBUG 1
>  
> -/* indicates that a refernce to this file has been taken via get_pmem_file,
> +/* indicates that a reference to this file has been taken via get_pmem_file,
>   * the file should not be released until put_pmem_file is called */
>  #define PMEM_FLAGS_BUSY 0x1
>  /* indicates that this is a suballocation of a larger master range */
> @@ -58,14 +58,14 @@ struct pmem_data {
>  	/* see flags above for descriptions */
>  	unsigned int flags;
>  	/* protects this data field, if the mm_mmap sem will be held at the
> -	 * same time as this sem, the mm sem must be taken first (as this is
> +	 * same time as this sem, the mm sem must be taken first as this is
>  	 * the order for vma_open and vma_close ops */
>  	struct rw_semaphore sem;
>  	/* info about the mmaping process */
>  	struct vm_area_struct *vma;
>  	/* task struct of the mapping process */
>  	struct task_struct *task;
> -	/* process id of teh mapping process */
> +	/* process id of the mapping process */
>  	pid_t pid;
>  	/* file descriptor of the master */
>  	int master_fd;
> @@ -138,7 +138,7 @@ struct pmem_info {
>  	 * dereferencing a pointer into bitmap
>  	 *
>  	 * pmem_data->sem protects the pmem data of a particular file
> -	 * Many of the function that require the pmem_data->sem have a non-
> +	 * Many of the functions that require the pmem_data->sem have a non-
>  	 * locking version for when the caller is already holding that sem.
>  	 *
>  	 * IF YOU TAKE BOTH LOCKS TAKE THEM IN THIS ORDER:
> @@ -296,7 +296,7 @@ static int pmem_release(struct inode *inode, struct file *file)
>  
>  	down_write(&data->sem);
>  
> -	/* if its not a conencted file and it has an allocation, free it */
> +	/* if its not a connected file and it has an allocation, free it */

	      it's

>  	if (!(PMEM_FLAGS_CONNECTED & data->flags) && has_allocation(file)) {
>  		down_write(&pmem[id].bitmap_sem);
>  		ret = pmem_free(id, data->index);


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
