Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439Ab1ECXQr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 19:16:47 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:37279 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755291Ab1ECXPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 19:15:04 -0400
Message-Id: <20110503231428.576806959@efficios.com>
User-Agent: quilt/0.48-1
Date: Tue, 03 May 2011 19:10:50 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>,
        Alex Elder <aelder@sgi.com>, Li Zefan <lizf@cn.fujitsu.com>
Subject: [RFC patch 27/32] trace event xfs remove semicolons
References: <20110503231023.968960757@efficios.com>
Content-Disposition: inline; filename=trace-event-xfs-remove-semicolons.patch
X-Poly-FromMTA: (test.dorsal.polymtl.ca [132.207.72.60]) at Tue,  3 May 2011 23:14:29 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Part of the gradual TRACE_EVENT() semicolon removal. Enables creation of array
of events, thus saving space for trace event probes.  Remove extra trailing
semicolons at the end of XFS trace event declarations.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Dave Chinner <david@fromorbit.com>
CC: Christoph Hellwig <hch@lst.de>
CC: Alex Elder <aelder@sgi.com>
CC: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/xfs/linux-2.6/xfs_trace.h |  534 +++++++++++++++++++++----------------------
 1 file changed, 267 insertions(+), 267 deletions(-)

Index: linux-2.6-lttng/fs/xfs/linux-2.6/xfs_trace.h
===================================================================
--- linux-2.6-lttng.orig/fs/xfs/linux-2.6/xfs_trace.h
+++ linux-2.6-lttng/fs/xfs/linux-2.6/xfs_trace.h
@@ -86,14 +86,14 @@ DECLARE_EVENT_CLASS(xfs_attr_list_class,
 DEFINE_EVENT(xfs_attr_list_class, name, \
 	TP_PROTO(struct xfs_attr_list_context *ctx), \
 	TP_ARGS(ctx))
-DEFINE_ATTR_LIST_EVENT(xfs_attr_list_sf);
-DEFINE_ATTR_LIST_EVENT(xfs_attr_list_sf_all);
-DEFINE_ATTR_LIST_EVENT(xfs_attr_list_leaf);
-DEFINE_ATTR_LIST_EVENT(xfs_attr_list_leaf_end);
-DEFINE_ATTR_LIST_EVENT(xfs_attr_list_full);
-DEFINE_ATTR_LIST_EVENT(xfs_attr_list_add);
-DEFINE_ATTR_LIST_EVENT(xfs_attr_list_wrong_blk);
-DEFINE_ATTR_LIST_EVENT(xfs_attr_list_notfound);
+DEFINE_ATTR_LIST_EVENT(xfs_attr_list_sf)
+DEFINE_ATTR_LIST_EVENT(xfs_attr_list_sf_all)
+DEFINE_ATTR_LIST_EVENT(xfs_attr_list_leaf)
+DEFINE_ATTR_LIST_EVENT(xfs_attr_list_leaf_end)
+DEFINE_ATTR_LIST_EVENT(xfs_attr_list_full)
+DEFINE_ATTR_LIST_EVENT(xfs_attr_list_add)
+DEFINE_ATTR_LIST_EVENT(xfs_attr_list_wrong_blk)
+DEFINE_ATTR_LIST_EVENT(xfs_attr_list_notfound)
 
 DECLARE_EVENT_CLASS(xfs_perag_class,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, int refcount,
@@ -116,18 +116,18 @@ DECLARE_EVENT_CLASS(xfs_perag_class,
 		  __entry->agno,
 		  __entry->refcount,
 		  (char *)__entry->caller_ip)
-);
+)
 
 #define DEFINE_PERAG_REF_EVENT(name)	\
 DEFINE_EVENT(xfs_perag_class, name,	\
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, int refcount,	\
 		 unsigned long caller_ip),					\
 	TP_ARGS(mp, agno, refcount, caller_ip))
-DEFINE_PERAG_REF_EVENT(xfs_perag_get);
-DEFINE_PERAG_REF_EVENT(xfs_perag_get_tag);
-DEFINE_PERAG_REF_EVENT(xfs_perag_put);
-DEFINE_PERAG_REF_EVENT(xfs_perag_set_reclaim);
-DEFINE_PERAG_REF_EVENT(xfs_perag_clear_reclaim);
+DEFINE_PERAG_REF_EVENT(xfs_perag_get)
+DEFINE_PERAG_REF_EVENT(xfs_perag_get_tag)
+DEFINE_PERAG_REF_EVENT(xfs_perag_put)
+DEFINE_PERAG_REF_EVENT(xfs_perag_set_reclaim)
+DEFINE_PERAG_REF_EVENT(xfs_perag_clear_reclaim)
 
 TRACE_EVENT(xfs_attr_list_node_descend,
 	TP_PROTO(struct xfs_attr_list_context *ctx,
@@ -179,7 +179,7 @@ TRACE_EVENT(xfs_attr_list_node_descend,
 		   __print_flags(__entry->flags, "|", XFS_ATTR_FLAGS),
 		   __entry->bt_hashval,
 		   __entry->bt_before)
-);
+)
 
 TRACE_EVENT(xfs_iext_insert,
 	TP_PROTO(struct xfs_inode *ip, xfs_extnum_t idx,
@@ -218,7 +218,7 @@ TRACE_EVENT(xfs_iext_insert,
 		  __entry->blockcount,
 		  __entry->state,
 		  (char *)__entry->caller_ip)
-);
+)
 
 DECLARE_EVENT_CLASS(xfs_bmap_class,
 	TP_PROTO(struct xfs_inode *ip, xfs_extnum_t idx, int state,
@@ -269,10 +269,10 @@ DEFINE_EVENT(xfs_bmap_class, name, \
 	TP_PROTO(struct xfs_inode *ip, xfs_extnum_t idx, int state, \
 		 unsigned long caller_ip), \
 	TP_ARGS(ip, idx, state, caller_ip))
-DEFINE_BMAP_EVENT(xfs_iext_remove);
-DEFINE_BMAP_EVENT(xfs_bmap_pre_update);
-DEFINE_BMAP_EVENT(xfs_bmap_post_update);
-DEFINE_BMAP_EVENT(xfs_extlist);
+DEFINE_BMAP_EVENT(xfs_iext_remove)
+DEFINE_BMAP_EVENT(xfs_bmap_pre_update)
+DEFINE_BMAP_EVENT(xfs_bmap_post_update)
+DEFINE_BMAP_EVENT(xfs_extlist)
 
 DECLARE_EVENT_CLASS(xfs_buf_class,
 	TP_PROTO(struct xfs_buf *bp, unsigned long caller_ip),
@@ -313,37 +313,37 @@ DECLARE_EVENT_CLASS(xfs_buf_class,
 DEFINE_EVENT(xfs_buf_class, name, \
 	TP_PROTO(struct xfs_buf *bp, unsigned long caller_ip), \
 	TP_ARGS(bp, caller_ip))
-DEFINE_BUF_EVENT(xfs_buf_init);
-DEFINE_BUF_EVENT(xfs_buf_free);
-DEFINE_BUF_EVENT(xfs_buf_hold);
-DEFINE_BUF_EVENT(xfs_buf_rele);
-DEFINE_BUF_EVENT(xfs_buf_iodone);
-DEFINE_BUF_EVENT(xfs_buf_iorequest);
-DEFINE_BUF_EVENT(xfs_buf_bawrite);
-DEFINE_BUF_EVENT(xfs_buf_bdwrite);
-DEFINE_BUF_EVENT(xfs_buf_lock);
-DEFINE_BUF_EVENT(xfs_buf_lock_done);
-DEFINE_BUF_EVENT(xfs_buf_cond_lock);
-DEFINE_BUF_EVENT(xfs_buf_unlock);
-DEFINE_BUF_EVENT(xfs_buf_iowait);
-DEFINE_BUF_EVENT(xfs_buf_iowait_done);
-DEFINE_BUF_EVENT(xfs_buf_delwri_queue);
-DEFINE_BUF_EVENT(xfs_buf_delwri_dequeue);
-DEFINE_BUF_EVENT(xfs_buf_delwri_split);
-DEFINE_BUF_EVENT(xfs_buf_get_uncached);
-DEFINE_BUF_EVENT(xfs_bdstrat_shut);
-DEFINE_BUF_EVENT(xfs_buf_item_relse);
-DEFINE_BUF_EVENT(xfs_buf_item_iodone);
-DEFINE_BUF_EVENT(xfs_buf_item_iodone_async);
-DEFINE_BUF_EVENT(xfs_buf_error_relse);
-DEFINE_BUF_EVENT(xfs_trans_read_buf_io);
-DEFINE_BUF_EVENT(xfs_trans_read_buf_shut);
+DEFINE_BUF_EVENT(xfs_buf_init)
+DEFINE_BUF_EVENT(xfs_buf_free)
+DEFINE_BUF_EVENT(xfs_buf_hold)
+DEFINE_BUF_EVENT(xfs_buf_rele)
+DEFINE_BUF_EVENT(xfs_buf_iodone)
+DEFINE_BUF_EVENT(xfs_buf_iorequest)
+DEFINE_BUF_EVENT(xfs_buf_bawrite)
+DEFINE_BUF_EVENT(xfs_buf_bdwrite)
+DEFINE_BUF_EVENT(xfs_buf_lock)
+DEFINE_BUF_EVENT(xfs_buf_lock_done)
+DEFINE_BUF_EVENT(xfs_buf_cond_lock)
+DEFINE_BUF_EVENT(xfs_buf_unlock)
+DEFINE_BUF_EVENT(xfs_buf_iowait)
+DEFINE_BUF_EVENT(xfs_buf_iowait_done)
+DEFINE_BUF_EVENT(xfs_buf_delwri_queue)
+DEFINE_BUF_EVENT(xfs_buf_delwri_dequeue)
+DEFINE_BUF_EVENT(xfs_buf_delwri_split)
+DEFINE_BUF_EVENT(xfs_buf_get_uncached)
+DEFINE_BUF_EVENT(xfs_bdstrat_shut)
+DEFINE_BUF_EVENT(xfs_buf_item_relse)
+DEFINE_BUF_EVENT(xfs_buf_item_iodone)
+DEFINE_BUF_EVENT(xfs_buf_item_iodone_async)
+DEFINE_BUF_EVENT(xfs_buf_error_relse)
+DEFINE_BUF_EVENT(xfs_trans_read_buf_io)
+DEFINE_BUF_EVENT(xfs_trans_read_buf_shut)
 
 /* not really buffer traces, but the buf provides useful information */
-DEFINE_BUF_EVENT(xfs_btree_corrupt);
-DEFINE_BUF_EVENT(xfs_da_btree_corrupt);
-DEFINE_BUF_EVENT(xfs_reset_dqcounts);
-DEFINE_BUF_EVENT(xfs_inode_item_push);
+DEFINE_BUF_EVENT(xfs_btree_corrupt)
+DEFINE_BUF_EVENT(xfs_da_btree_corrupt)
+DEFINE_BUF_EVENT(xfs_reset_dqcounts)
+DEFINE_BUF_EVENT(xfs_inode_item_push)
 
 /* pass flags explicitly */
 DECLARE_EVENT_CLASS(xfs_buf_flags_class,
@@ -385,9 +385,9 @@ DECLARE_EVENT_CLASS(xfs_buf_flags_class,
 DEFINE_EVENT(xfs_buf_flags_class, name, \
 	TP_PROTO(struct xfs_buf *bp, unsigned flags, unsigned long caller_ip), \
 	TP_ARGS(bp, flags, caller_ip))
-DEFINE_BUF_FLAGS_EVENT(xfs_buf_find);
-DEFINE_BUF_FLAGS_EVENT(xfs_buf_get);
-DEFINE_BUF_FLAGS_EVENT(xfs_buf_read);
+DEFINE_BUF_FLAGS_EVENT(xfs_buf_find)
+DEFINE_BUF_FLAGS_EVENT(xfs_buf_get)
+DEFINE_BUF_FLAGS_EVENT(xfs_buf_read)
 
 TRACE_EVENT(xfs_buf_ioerror,
 	TP_PROTO(struct xfs_buf *bp, int error, unsigned long caller_ip),
@@ -425,7 +425,7 @@ TRACE_EVENT(xfs_buf_ioerror,
 		  __entry->error,
 		  __print_flags(__entry->flags, "|", XFS_BUF_FLAGS),
 		  (void *)__entry->caller_ip)
-);
+)
 
 DECLARE_EVENT_CLASS(xfs_buf_item_class,
 	TP_PROTO(struct xfs_buf_log_item *bip),
@@ -479,31 +479,31 @@ DECLARE_EVENT_CLASS(xfs_buf_item_class,
 DEFINE_EVENT(xfs_buf_item_class, name, \
 	TP_PROTO(struct xfs_buf_log_item *bip), \
 	TP_ARGS(bip))
-DEFINE_BUF_ITEM_EVENT(xfs_buf_item_size);
-DEFINE_BUF_ITEM_EVENT(xfs_buf_item_size_stale);
-DEFINE_BUF_ITEM_EVENT(xfs_buf_item_format);
-DEFINE_BUF_ITEM_EVENT(xfs_buf_item_format_stale);
-DEFINE_BUF_ITEM_EVENT(xfs_buf_item_pin);
-DEFINE_BUF_ITEM_EVENT(xfs_buf_item_unpin);
-DEFINE_BUF_ITEM_EVENT(xfs_buf_item_unpin_stale);
-DEFINE_BUF_ITEM_EVENT(xfs_buf_item_trylock);
-DEFINE_BUF_ITEM_EVENT(xfs_buf_item_unlock);
-DEFINE_BUF_ITEM_EVENT(xfs_buf_item_unlock_stale);
-DEFINE_BUF_ITEM_EVENT(xfs_buf_item_committed);
-DEFINE_BUF_ITEM_EVENT(xfs_buf_item_push);
-DEFINE_BUF_ITEM_EVENT(xfs_buf_item_pushbuf);
-DEFINE_BUF_ITEM_EVENT(xfs_trans_get_buf);
-DEFINE_BUF_ITEM_EVENT(xfs_trans_get_buf_recur);
-DEFINE_BUF_ITEM_EVENT(xfs_trans_getsb);
-DEFINE_BUF_ITEM_EVENT(xfs_trans_getsb_recur);
-DEFINE_BUF_ITEM_EVENT(xfs_trans_read_buf);
-DEFINE_BUF_ITEM_EVENT(xfs_trans_read_buf_recur);
-DEFINE_BUF_ITEM_EVENT(xfs_trans_log_buf);
-DEFINE_BUF_ITEM_EVENT(xfs_trans_brelse);
-DEFINE_BUF_ITEM_EVENT(xfs_trans_bjoin);
-DEFINE_BUF_ITEM_EVENT(xfs_trans_bhold);
-DEFINE_BUF_ITEM_EVENT(xfs_trans_bhold_release);
-DEFINE_BUF_ITEM_EVENT(xfs_trans_binval);
+DEFINE_BUF_ITEM_EVENT(xfs_buf_item_size)
+DEFINE_BUF_ITEM_EVENT(xfs_buf_item_size_stale)
+DEFINE_BUF_ITEM_EVENT(xfs_buf_item_format)
+DEFINE_BUF_ITEM_EVENT(xfs_buf_item_format_stale)
+DEFINE_BUF_ITEM_EVENT(xfs_buf_item_pin)
+DEFINE_BUF_ITEM_EVENT(xfs_buf_item_unpin)
+DEFINE_BUF_ITEM_EVENT(xfs_buf_item_unpin_stale)
+DEFINE_BUF_ITEM_EVENT(xfs_buf_item_trylock)
+DEFINE_BUF_ITEM_EVENT(xfs_buf_item_unlock)
+DEFINE_BUF_ITEM_EVENT(xfs_buf_item_unlock_stale)
+DEFINE_BUF_ITEM_EVENT(xfs_buf_item_committed)
+DEFINE_BUF_ITEM_EVENT(xfs_buf_item_push)
+DEFINE_BUF_ITEM_EVENT(xfs_buf_item_pushbuf)
+DEFINE_BUF_ITEM_EVENT(xfs_trans_get_buf)
+DEFINE_BUF_ITEM_EVENT(xfs_trans_get_buf_recur)
+DEFINE_BUF_ITEM_EVENT(xfs_trans_getsb)
+DEFINE_BUF_ITEM_EVENT(xfs_trans_getsb_recur)
+DEFINE_BUF_ITEM_EVENT(xfs_trans_read_buf)
+DEFINE_BUF_ITEM_EVENT(xfs_trans_read_buf_recur)
+DEFINE_BUF_ITEM_EVENT(xfs_trans_log_buf)
+DEFINE_BUF_ITEM_EVENT(xfs_trans_brelse)
+DEFINE_BUF_ITEM_EVENT(xfs_trans_bjoin)
+DEFINE_BUF_ITEM_EVENT(xfs_trans_bhold)
+DEFINE_BUF_ITEM_EVENT(xfs_trans_bhold_release)
+DEFINE_BUF_ITEM_EVENT(xfs_trans_binval)
 
 DECLARE_EVENT_CLASS(xfs_lock_class,
 	TP_PROTO(struct xfs_inode *ip, unsigned lock_flags,
@@ -533,10 +533,10 @@ DEFINE_EVENT(xfs_lock_class, name, \
 	TP_PROTO(struct xfs_inode *ip, unsigned lock_flags, \
 		 unsigned long caller_ip), \
 	TP_ARGS(ip,  lock_flags, caller_ip))
-DEFINE_LOCK_EVENT(xfs_ilock);
-DEFINE_LOCK_EVENT(xfs_ilock_nowait);
-DEFINE_LOCK_EVENT(xfs_ilock_demote);
-DEFINE_LOCK_EVENT(xfs_iunlock);
+DEFINE_LOCK_EVENT(xfs_ilock)
+DEFINE_LOCK_EVENT(xfs_ilock_nowait)
+DEFINE_LOCK_EVENT(xfs_ilock_demote)
+DEFINE_LOCK_EVENT(xfs_iunlock)
 
 DECLARE_EVENT_CLASS(xfs_inode_class,
 	TP_PROTO(struct xfs_inode *ip),
@@ -558,32 +558,32 @@ DECLARE_EVENT_CLASS(xfs_inode_class,
 DEFINE_EVENT(xfs_inode_class, name, \
 	TP_PROTO(struct xfs_inode *ip), \
 	TP_ARGS(ip))
-DEFINE_INODE_EVENT(xfs_iget_skip);
-DEFINE_INODE_EVENT(xfs_iget_reclaim);
-DEFINE_INODE_EVENT(xfs_iget_reclaim_fail);
-DEFINE_INODE_EVENT(xfs_iget_hit);
-DEFINE_INODE_EVENT(xfs_iget_miss);
-
-DEFINE_INODE_EVENT(xfs_getattr);
-DEFINE_INODE_EVENT(xfs_setattr);
-DEFINE_INODE_EVENT(xfs_readlink);
-DEFINE_INODE_EVENT(xfs_alloc_file_space);
-DEFINE_INODE_EVENT(xfs_free_file_space);
-DEFINE_INODE_EVENT(xfs_readdir);
+DEFINE_INODE_EVENT(xfs_iget_skip)
+DEFINE_INODE_EVENT(xfs_iget_reclaim)
+DEFINE_INODE_EVENT(xfs_iget_reclaim_fail)
+DEFINE_INODE_EVENT(xfs_iget_hit)
+DEFINE_INODE_EVENT(xfs_iget_miss)
+
+DEFINE_INODE_EVENT(xfs_getattr)
+DEFINE_INODE_EVENT(xfs_setattr)
+DEFINE_INODE_EVENT(xfs_readlink)
+DEFINE_INODE_EVENT(xfs_alloc_file_space)
+DEFINE_INODE_EVENT(xfs_free_file_space)
+DEFINE_INODE_EVENT(xfs_readdir)
 #ifdef CONFIG_XFS_POSIX_ACL
-DEFINE_INODE_EVENT(xfs_check_acl);
+DEFINE_INODE_EVENT(xfs_check_acl)
 #endif
-DEFINE_INODE_EVENT(xfs_vm_bmap);
-DEFINE_INODE_EVENT(xfs_file_ioctl);
-DEFINE_INODE_EVENT(xfs_file_compat_ioctl);
-DEFINE_INODE_EVENT(xfs_ioctl_setattr);
-DEFINE_INODE_EVENT(xfs_file_fsync);
-DEFINE_INODE_EVENT(xfs_destroy_inode);
-DEFINE_INODE_EVENT(xfs_write_inode);
-DEFINE_INODE_EVENT(xfs_evict_inode);
+DEFINE_INODE_EVENT(xfs_vm_bmap)
+DEFINE_INODE_EVENT(xfs_file_ioctl)
+DEFINE_INODE_EVENT(xfs_file_compat_ioctl)
+DEFINE_INODE_EVENT(xfs_ioctl_setattr)
+DEFINE_INODE_EVENT(xfs_file_fsync)
+DEFINE_INODE_EVENT(xfs_destroy_inode)
+DEFINE_INODE_EVENT(xfs_write_inode)
+DEFINE_INODE_EVENT(xfs_evict_inode)
 
-DEFINE_INODE_EVENT(xfs_dquot_dqalloc);
-DEFINE_INODE_EVENT(xfs_dquot_dqdetach);
+DEFINE_INODE_EVENT(xfs_dquot_dqalloc)
+DEFINE_INODE_EVENT(xfs_dquot_dqdetach)
 
 DECLARE_EVENT_CLASS(xfs_iref_class,
 	TP_PROTO(struct xfs_inode *ip, unsigned long caller_ip),
@@ -614,11 +614,11 @@ DECLARE_EVENT_CLASS(xfs_iref_class,
 DEFINE_EVENT(xfs_iref_class, name, \
 	TP_PROTO(struct xfs_inode *ip, unsigned long caller_ip), \
 	TP_ARGS(ip, caller_ip))
-DEFINE_IREF_EVENT(xfs_ihold);
-DEFINE_IREF_EVENT(xfs_irele);
-DEFINE_IREF_EVENT(xfs_inode_pin);
-DEFINE_IREF_EVENT(xfs_inode_unpin);
-DEFINE_IREF_EVENT(xfs_inode_unpin_nowait);
+DEFINE_IREF_EVENT(xfs_ihold)
+DEFINE_IREF_EVENT(xfs_irele)
+DEFINE_IREF_EVENT(xfs_inode_pin)
+DEFINE_IREF_EVENT(xfs_inode_unpin)
+DEFINE_IREF_EVENT(xfs_inode_unpin_nowait)
 
 DECLARE_EVENT_CLASS(xfs_namespace_class,
 	TP_PROTO(struct xfs_inode *dp, struct xfs_name *name),
@@ -643,11 +643,11 @@ DECLARE_EVENT_CLASS(xfs_namespace_class,
 DEFINE_EVENT(xfs_namespace_class, name, \
 	TP_PROTO(struct xfs_inode *dp, struct xfs_name *name), \
 	TP_ARGS(dp, name))
-DEFINE_NAMESPACE_EVENT(xfs_remove);
-DEFINE_NAMESPACE_EVENT(xfs_link);
-DEFINE_NAMESPACE_EVENT(xfs_lookup);
-DEFINE_NAMESPACE_EVENT(xfs_create);
-DEFINE_NAMESPACE_EVENT(xfs_symlink);
+DEFINE_NAMESPACE_EVENT(xfs_remove)
+DEFINE_NAMESPACE_EVENT(xfs_link)
+DEFINE_NAMESPACE_EVENT(xfs_lookup)
+DEFINE_NAMESPACE_EVENT(xfs_create)
+DEFINE_NAMESPACE_EVENT(xfs_symlink)
 
 TRACE_EVENT(xfs_rename,
 	TP_PROTO(struct xfs_inode *src_dp, struct xfs_inode *target_dp,
@@ -729,31 +729,31 @@ DECLARE_EVENT_CLASS(xfs_dquot_class,
 DEFINE_EVENT(xfs_dquot_class, name, \
 	TP_PROTO(struct xfs_dquot *dqp), \
 	TP_ARGS(dqp))
-DEFINE_DQUOT_EVENT(xfs_dqadjust);
-DEFINE_DQUOT_EVENT(xfs_dqreclaim_want);
-DEFINE_DQUOT_EVENT(xfs_dqreclaim_dirty);
-DEFINE_DQUOT_EVENT(xfs_dqreclaim_unlink);
-DEFINE_DQUOT_EVENT(xfs_dqattach_found);
-DEFINE_DQUOT_EVENT(xfs_dqattach_get);
-DEFINE_DQUOT_EVENT(xfs_dqinit);
-DEFINE_DQUOT_EVENT(xfs_dqreuse);
-DEFINE_DQUOT_EVENT(xfs_dqalloc);
-DEFINE_DQUOT_EVENT(xfs_dqtobp_read);
-DEFINE_DQUOT_EVENT(xfs_dqread);
-DEFINE_DQUOT_EVENT(xfs_dqread_fail);
-DEFINE_DQUOT_EVENT(xfs_dqlookup_found);
-DEFINE_DQUOT_EVENT(xfs_dqlookup_want);
-DEFINE_DQUOT_EVENT(xfs_dqlookup_freelist);
-DEFINE_DQUOT_EVENT(xfs_dqlookup_done);
-DEFINE_DQUOT_EVENT(xfs_dqget_hit);
-DEFINE_DQUOT_EVENT(xfs_dqget_miss);
-DEFINE_DQUOT_EVENT(xfs_dqput);
-DEFINE_DQUOT_EVENT(xfs_dqput_wait);
-DEFINE_DQUOT_EVENT(xfs_dqput_free);
-DEFINE_DQUOT_EVENT(xfs_dqrele);
-DEFINE_DQUOT_EVENT(xfs_dqflush);
-DEFINE_DQUOT_EVENT(xfs_dqflush_force);
-DEFINE_DQUOT_EVENT(xfs_dqflush_done);
+DEFINE_DQUOT_EVENT(xfs_dqadjust)
+DEFINE_DQUOT_EVENT(xfs_dqreclaim_want)
+DEFINE_DQUOT_EVENT(xfs_dqreclaim_dirty)
+DEFINE_DQUOT_EVENT(xfs_dqreclaim_unlink)
+DEFINE_DQUOT_EVENT(xfs_dqattach_found)
+DEFINE_DQUOT_EVENT(xfs_dqattach_get)
+DEFINE_DQUOT_EVENT(xfs_dqinit)
+DEFINE_DQUOT_EVENT(xfs_dqreuse)
+DEFINE_DQUOT_EVENT(xfs_dqalloc)
+DEFINE_DQUOT_EVENT(xfs_dqtobp_read)
+DEFINE_DQUOT_EVENT(xfs_dqread)
+DEFINE_DQUOT_EVENT(xfs_dqread_fail)
+DEFINE_DQUOT_EVENT(xfs_dqlookup_found)
+DEFINE_DQUOT_EVENT(xfs_dqlookup_want)
+DEFINE_DQUOT_EVENT(xfs_dqlookup_freelist)
+DEFINE_DQUOT_EVENT(xfs_dqlookup_done)
+DEFINE_DQUOT_EVENT(xfs_dqget_hit)
+DEFINE_DQUOT_EVENT(xfs_dqget_miss)
+DEFINE_DQUOT_EVENT(xfs_dqput)
+DEFINE_DQUOT_EVENT(xfs_dqput_wait)
+DEFINE_DQUOT_EVENT(xfs_dqput_free)
+DEFINE_DQUOT_EVENT(xfs_dqrele)
+DEFINE_DQUOT_EVENT(xfs_dqflush)
+DEFINE_DQUOT_EVENT(xfs_dqflush_force)
+DEFINE_DQUOT_EVENT(xfs_dqflush_done)
 
 DECLARE_EVENT_CLASS(xfs_loggrant_class,
 	TP_PROTO(struct log *log, struct xlog_ticket *tic),
@@ -826,32 +826,32 @@ DECLARE_EVENT_CLASS(xfs_loggrant_class,
 DEFINE_EVENT(xfs_loggrant_class, name, \
 	TP_PROTO(struct log *log, struct xlog_ticket *tic), \
 	TP_ARGS(log, tic))
-DEFINE_LOGGRANT_EVENT(xfs_log_done_nonperm);
-DEFINE_LOGGRANT_EVENT(xfs_log_done_perm);
-DEFINE_LOGGRANT_EVENT(xfs_log_reserve);
-DEFINE_LOGGRANT_EVENT(xfs_log_umount_write);
-DEFINE_LOGGRANT_EVENT(xfs_log_grant_enter);
-DEFINE_LOGGRANT_EVENT(xfs_log_grant_exit);
-DEFINE_LOGGRANT_EVENT(xfs_log_grant_error);
-DEFINE_LOGGRANT_EVENT(xfs_log_grant_sleep1);
-DEFINE_LOGGRANT_EVENT(xfs_log_grant_wake1);
-DEFINE_LOGGRANT_EVENT(xfs_log_grant_sleep2);
-DEFINE_LOGGRANT_EVENT(xfs_log_grant_wake2);
-DEFINE_LOGGRANT_EVENT(xfs_log_grant_wake_up);
-DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_enter);
-DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_exit);
-DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_error);
-DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_sleep1);
-DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_wake1);
-DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_sleep2);
-DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_wake2);
-DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_wake_up);
-DEFINE_LOGGRANT_EVENT(xfs_log_regrant_reserve_enter);
-DEFINE_LOGGRANT_EVENT(xfs_log_regrant_reserve_exit);
-DEFINE_LOGGRANT_EVENT(xfs_log_regrant_reserve_sub);
-DEFINE_LOGGRANT_EVENT(xfs_log_ungrant_enter);
-DEFINE_LOGGRANT_EVENT(xfs_log_ungrant_exit);
-DEFINE_LOGGRANT_EVENT(xfs_log_ungrant_sub);
+DEFINE_LOGGRANT_EVENT(xfs_log_done_nonperm)
+DEFINE_LOGGRANT_EVENT(xfs_log_done_perm)
+DEFINE_LOGGRANT_EVENT(xfs_log_reserve)
+DEFINE_LOGGRANT_EVENT(xfs_log_umount_write)
+DEFINE_LOGGRANT_EVENT(xfs_log_grant_enter)
+DEFINE_LOGGRANT_EVENT(xfs_log_grant_exit)
+DEFINE_LOGGRANT_EVENT(xfs_log_grant_error)
+DEFINE_LOGGRANT_EVENT(xfs_log_grant_sleep1)
+DEFINE_LOGGRANT_EVENT(xfs_log_grant_wake1)
+DEFINE_LOGGRANT_EVENT(xfs_log_grant_sleep2)
+DEFINE_LOGGRANT_EVENT(xfs_log_grant_wake2)
+DEFINE_LOGGRANT_EVENT(xfs_log_grant_wake_up)
+DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_enter)
+DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_exit)
+DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_error)
+DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_sleep1)
+DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_wake1)
+DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_sleep2)
+DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_wake2)
+DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_wake_up)
+DEFINE_LOGGRANT_EVENT(xfs_log_regrant_reserve_enter)
+DEFINE_LOGGRANT_EVENT(xfs_log_regrant_reserve_exit)
+DEFINE_LOGGRANT_EVENT(xfs_log_regrant_reserve_sub)
+DEFINE_LOGGRANT_EVENT(xfs_log_ungrant_enter)
+DEFINE_LOGGRANT_EVENT(xfs_log_ungrant_exit)
+DEFINE_LOGGRANT_EVENT(xfs_log_ungrant_sub)
 
 DECLARE_EVENT_CLASS(xfs_file_class,
 	TP_PROTO(struct xfs_inode *ip, size_t count, loff_t offset, int flags),
@@ -889,11 +889,11 @@ DECLARE_EVENT_CLASS(xfs_file_class,
 DEFINE_EVENT(xfs_file_class, name,	\
 	TP_PROTO(struct xfs_inode *ip, size_t count, loff_t offset, int flags),	\
 	TP_ARGS(ip, count, offset, flags))
-DEFINE_RW_EVENT(xfs_file_read);
-DEFINE_RW_EVENT(xfs_file_buffered_write);
-DEFINE_RW_EVENT(xfs_file_direct_write);
-DEFINE_RW_EVENT(xfs_file_splice_read);
-DEFINE_RW_EVENT(xfs_file_splice_write);
+DEFINE_RW_EVENT(xfs_file_read)
+DEFINE_RW_EVENT(xfs_file_buffered_write)
+DEFINE_RW_EVENT(xfs_file_direct_write)
+DEFINE_RW_EVENT(xfs_file_splice_read)
+DEFINE_RW_EVENT(xfs_file_splice_write)
 
 DECLARE_EVENT_CLASS(xfs_page_class,
 	TP_PROTO(struct inode *inode, struct page *page, unsigned long off),
@@ -935,9 +935,9 @@ DECLARE_EVENT_CLASS(xfs_page_class,
 DEFINE_EVENT(xfs_page_class, name,	\
 	TP_PROTO(struct inode *inode, struct page *page, unsigned long off),	\
 	TP_ARGS(inode, page, off))
-DEFINE_PAGE_EVENT(xfs_writepage);
-DEFINE_PAGE_EVENT(xfs_releasepage);
-DEFINE_PAGE_EVENT(xfs_invalidatepage);
+DEFINE_PAGE_EVENT(xfs_writepage)
+DEFINE_PAGE_EVENT(xfs_releasepage)
+DEFINE_PAGE_EVENT(xfs_invalidatepage)
 
 DECLARE_EVENT_CLASS(xfs_imap_class,
 	TP_PROTO(struct xfs_inode *ip, xfs_off_t offset, ssize_t count,
@@ -987,10 +987,10 @@ DEFINE_EVENT(xfs_imap_class, name,	\
 	TP_PROTO(struct xfs_inode *ip, xfs_off_t offset, ssize_t count,	\
 		 int type, struct xfs_bmbt_irec *irec),		\
 	TP_ARGS(ip, offset, count, type, irec))
-DEFINE_IOMAP_EVENT(xfs_map_blocks_found);
-DEFINE_IOMAP_EVENT(xfs_map_blocks_alloc);
-DEFINE_IOMAP_EVENT(xfs_get_blocks_found);
-DEFINE_IOMAP_EVENT(xfs_get_blocks_alloc);
+DEFINE_IOMAP_EVENT(xfs_map_blocks_found)
+DEFINE_IOMAP_EVENT(xfs_map_blocks_alloc)
+DEFINE_IOMAP_EVENT(xfs_get_blocks_found)
+DEFINE_IOMAP_EVENT(xfs_get_blocks_alloc)
 
 DECLARE_EVENT_CLASS(xfs_simple_io_class,
 	TP_PROTO(struct xfs_inode *ip, xfs_off_t offset, ssize_t count),
@@ -1019,15 +1019,15 @@ DECLARE_EVENT_CLASS(xfs_simple_io_class,
 		  __entry->new_size,
 		  __entry->offset,
 		  __entry->count)
-);
+)
 
 #define DEFINE_SIMPLE_IO_EVENT(name)	\
 DEFINE_EVENT(xfs_simple_io_class, name,	\
 	TP_PROTO(struct xfs_inode *ip, xfs_off_t offset, ssize_t count),	\
 	TP_ARGS(ip, offset, count))
-DEFINE_SIMPLE_IO_EVENT(xfs_delalloc_enospc);
-DEFINE_SIMPLE_IO_EVENT(xfs_unwritten_convert);
-DEFINE_SIMPLE_IO_EVENT(xfs_get_blocks_notfound);
+DEFINE_SIMPLE_IO_EVENT(xfs_delalloc_enospc)
+DEFINE_SIMPLE_IO_EVENT(xfs_unwritten_convert)
+DEFINE_SIMPLE_IO_EVENT(xfs_get_blocks_notfound)
 
 
 TRACE_EVENT(xfs_itruncate_start,
@@ -1061,7 +1061,7 @@ TRACE_EVENT(xfs_itruncate_start,
 		  __entry->new_size,
 		  __entry->toss_start,
 		  __entry->toss_finish)
-);
+)
 
 DECLARE_EVENT_CLASS(xfs_itrunc_class,
 	TP_PROTO(struct xfs_inode *ip, xfs_fsize_t new_size),
@@ -1089,8 +1089,8 @@ DECLARE_EVENT_CLASS(xfs_itrunc_class,
 DEFINE_EVENT(xfs_itrunc_class, name, \
 	TP_PROTO(struct xfs_inode *ip, xfs_fsize_t new_size), \
 	TP_ARGS(ip, new_size))
-DEFINE_ITRUNC_EVENT(xfs_itruncate_finish_start);
-DEFINE_ITRUNC_EVENT(xfs_itruncate_finish_end);
+DEFINE_ITRUNC_EVENT(xfs_itruncate_finish_start)
+DEFINE_ITRUNC_EVENT(xfs_itruncate_finish_end)
 
 TRACE_EVENT(xfs_pagecache_inval,
 	TP_PROTO(struct xfs_inode *ip, xfs_off_t start, xfs_off_t finish),
@@ -1115,7 +1115,7 @@ TRACE_EVENT(xfs_pagecache_inval,
 		  __entry->size,
 		  __entry->start,
 		  __entry->finish)
-);
+)
 
 TRACE_EVENT(xfs_bunmap,
 	TP_PROTO(struct xfs_inode *ip, xfs_fileoff_t bno, xfs_filblks_t len,
@@ -1149,7 +1149,7 @@ TRACE_EVENT(xfs_bunmap,
 		  __print_flags(__entry->flags, "|", XFS_BMAPI_FLAGS),
 		  (void *)__entry->caller_ip)
 
-);
+)
 
 #define XFS_BUSY_SYNC \
 	{ 0,	"async" }, \
@@ -1186,7 +1186,7 @@ TRACE_EVENT(xfs_alloc_busy,
 		  __entry->len,
 		  __print_symbolic(__entry->sync, XFS_BUSY_SYNC))
 
-);
+)
 
 TRACE_EVENT(xfs_alloc_unbusy,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
@@ -1209,7 +1209,7 @@ TRACE_EVENT(xfs_alloc_unbusy,
 		  __entry->agno,
 		  __entry->agbno,
 		  __entry->len)
-);
+)
 
 #define XFS_BUSY_STATES \
 	{ 0,	"missing" }, \
@@ -1239,7 +1239,7 @@ TRACE_EVENT(xfs_alloc_busysearch,
 		  __entry->agbno,
 		  __entry->len,
 		  __print_symbolic(__entry->found, XFS_BUSY_STATES))
-);
+)
 
 TRACE_EVENT(xfs_trans_commit_lsn,
 	TP_PROTO(struct xfs_trans *trans),
@@ -1258,7 +1258,7 @@ TRACE_EVENT(xfs_trans_commit_lsn,
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->tp,
 		  __entry->lsn)
-);
+)
 
 TRACE_EVENT(xfs_agf,
 	TP_PROTO(struct xfs_mount *mp, struct xfs_agf *agf, int flags,
@@ -1315,7 +1315,7 @@ TRACE_EVENT(xfs_agf,
 		  __entry->freeblks,
 		  __entry->longest,
 		  (void *)__entry->caller_ip)
-);
+)
 
 TRACE_EVENT(xfs_free_extent,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, xfs_agblock_t agbno,
@@ -1349,7 +1349,7 @@ TRACE_EVENT(xfs_free_extent,
 			(__entry->haveright ? "both" : "left") :
 			(__entry->haveright ? "right" : "none"))
 
-);
+)
 
 DECLARE_EVENT_CLASS(xfs_alloc_class,
 	TP_PROTO(struct xfs_alloc_arg *args),
@@ -1425,28 +1425,28 @@ DECLARE_EVENT_CLASS(xfs_alloc_class,
 DEFINE_EVENT(xfs_alloc_class, name, \
 	TP_PROTO(struct xfs_alloc_arg *args), \
 	TP_ARGS(args))
-DEFINE_ALLOC_EVENT(xfs_alloc_exact_done);
-DEFINE_ALLOC_EVENT(xfs_alloc_exact_notfound);
-DEFINE_ALLOC_EVENT(xfs_alloc_exact_error);
-DEFINE_ALLOC_EVENT(xfs_alloc_near_nominleft);
-DEFINE_ALLOC_EVENT(xfs_alloc_near_first);
-DEFINE_ALLOC_EVENT(xfs_alloc_near_greater);
-DEFINE_ALLOC_EVENT(xfs_alloc_near_lesser);
-DEFINE_ALLOC_EVENT(xfs_alloc_near_error);
-DEFINE_ALLOC_EVENT(xfs_alloc_size_neither);
-DEFINE_ALLOC_EVENT(xfs_alloc_size_noentry);
-DEFINE_ALLOC_EVENT(xfs_alloc_size_nominleft);
-DEFINE_ALLOC_EVENT(xfs_alloc_size_done);
-DEFINE_ALLOC_EVENT(xfs_alloc_size_error);
-DEFINE_ALLOC_EVENT(xfs_alloc_small_freelist);
-DEFINE_ALLOC_EVENT(xfs_alloc_small_notenough);
-DEFINE_ALLOC_EVENT(xfs_alloc_small_done);
-DEFINE_ALLOC_EVENT(xfs_alloc_small_error);
-DEFINE_ALLOC_EVENT(xfs_alloc_vextent_badargs);
-DEFINE_ALLOC_EVENT(xfs_alloc_vextent_nofix);
-DEFINE_ALLOC_EVENT(xfs_alloc_vextent_noagbp);
-DEFINE_ALLOC_EVENT(xfs_alloc_vextent_loopfailed);
-DEFINE_ALLOC_EVENT(xfs_alloc_vextent_allfailed);
+DEFINE_ALLOC_EVENT(xfs_alloc_exact_done)
+DEFINE_ALLOC_EVENT(xfs_alloc_exact_notfound)
+DEFINE_ALLOC_EVENT(xfs_alloc_exact_error)
+DEFINE_ALLOC_EVENT(xfs_alloc_near_nominleft)
+DEFINE_ALLOC_EVENT(xfs_alloc_near_first)
+DEFINE_ALLOC_EVENT(xfs_alloc_near_greater)
+DEFINE_ALLOC_EVENT(xfs_alloc_near_lesser)
+DEFINE_ALLOC_EVENT(xfs_alloc_near_error)
+DEFINE_ALLOC_EVENT(xfs_alloc_size_neither)
+DEFINE_ALLOC_EVENT(xfs_alloc_size_noentry)
+DEFINE_ALLOC_EVENT(xfs_alloc_size_nominleft)
+DEFINE_ALLOC_EVENT(xfs_alloc_size_done)
+DEFINE_ALLOC_EVENT(xfs_alloc_size_error)
+DEFINE_ALLOC_EVENT(xfs_alloc_small_freelist)
+DEFINE_ALLOC_EVENT(xfs_alloc_small_notenough)
+DEFINE_ALLOC_EVENT(xfs_alloc_small_done)
+DEFINE_ALLOC_EVENT(xfs_alloc_small_error)
+DEFINE_ALLOC_EVENT(xfs_alloc_vextent_badargs)
+DEFINE_ALLOC_EVENT(xfs_alloc_vextent_nofix)
+DEFINE_ALLOC_EVENT(xfs_alloc_vextent_noagbp)
+DEFINE_ALLOC_EVENT(xfs_alloc_vextent_loopfailed)
+DEFINE_ALLOC_EVENT(xfs_alloc_vextent_allfailed)
 
 DECLARE_EVENT_CLASS(xfs_dir2_class,
 	TP_PROTO(struct xfs_da_args *args),
@@ -1486,31 +1486,31 @@ DECLARE_EVENT_CLASS(xfs_dir2_class,
 DEFINE_EVENT(xfs_dir2_class, name, \
 	TP_PROTO(struct xfs_da_args *args), \
 	TP_ARGS(args))
-DEFINE_DIR2_EVENT(xfs_dir2_sf_addname);
-DEFINE_DIR2_EVENT(xfs_dir2_sf_create);
-DEFINE_DIR2_EVENT(xfs_dir2_sf_lookup);
-DEFINE_DIR2_EVENT(xfs_dir2_sf_replace);
-DEFINE_DIR2_EVENT(xfs_dir2_sf_removename);
-DEFINE_DIR2_EVENT(xfs_dir2_sf_toino4);
-DEFINE_DIR2_EVENT(xfs_dir2_sf_toino8);
-DEFINE_DIR2_EVENT(xfs_dir2_sf_to_block);
-DEFINE_DIR2_EVENT(xfs_dir2_block_addname);
-DEFINE_DIR2_EVENT(xfs_dir2_block_lookup);
-DEFINE_DIR2_EVENT(xfs_dir2_block_replace);
-DEFINE_DIR2_EVENT(xfs_dir2_block_removename);
-DEFINE_DIR2_EVENT(xfs_dir2_block_to_sf);
-DEFINE_DIR2_EVENT(xfs_dir2_block_to_leaf);
-DEFINE_DIR2_EVENT(xfs_dir2_leaf_addname);
-DEFINE_DIR2_EVENT(xfs_dir2_leaf_lookup);
-DEFINE_DIR2_EVENT(xfs_dir2_leaf_replace);
-DEFINE_DIR2_EVENT(xfs_dir2_leaf_removename);
-DEFINE_DIR2_EVENT(xfs_dir2_leaf_to_block);
-DEFINE_DIR2_EVENT(xfs_dir2_leaf_to_node);
-DEFINE_DIR2_EVENT(xfs_dir2_node_addname);
-DEFINE_DIR2_EVENT(xfs_dir2_node_lookup);
-DEFINE_DIR2_EVENT(xfs_dir2_node_replace);
-DEFINE_DIR2_EVENT(xfs_dir2_node_removename);
-DEFINE_DIR2_EVENT(xfs_dir2_node_to_leaf);
+DEFINE_DIR2_EVENT(xfs_dir2_sf_addname)
+DEFINE_DIR2_EVENT(xfs_dir2_sf_create)
+DEFINE_DIR2_EVENT(xfs_dir2_sf_lookup)
+DEFINE_DIR2_EVENT(xfs_dir2_sf_replace)
+DEFINE_DIR2_EVENT(xfs_dir2_sf_removename)
+DEFINE_DIR2_EVENT(xfs_dir2_sf_toino4)
+DEFINE_DIR2_EVENT(xfs_dir2_sf_toino8)
+DEFINE_DIR2_EVENT(xfs_dir2_sf_to_block)
+DEFINE_DIR2_EVENT(xfs_dir2_block_addname)
+DEFINE_DIR2_EVENT(xfs_dir2_block_lookup)
+DEFINE_DIR2_EVENT(xfs_dir2_block_replace)
+DEFINE_DIR2_EVENT(xfs_dir2_block_removename)
+DEFINE_DIR2_EVENT(xfs_dir2_block_to_sf)
+DEFINE_DIR2_EVENT(xfs_dir2_block_to_leaf)
+DEFINE_DIR2_EVENT(xfs_dir2_leaf_addname)
+DEFINE_DIR2_EVENT(xfs_dir2_leaf_lookup)
+DEFINE_DIR2_EVENT(xfs_dir2_leaf_replace)
+DEFINE_DIR2_EVENT(xfs_dir2_leaf_removename)
+DEFINE_DIR2_EVENT(xfs_dir2_leaf_to_block)
+DEFINE_DIR2_EVENT(xfs_dir2_leaf_to_node)
+DEFINE_DIR2_EVENT(xfs_dir2_node_addname)
+DEFINE_DIR2_EVENT(xfs_dir2_node_lookup)
+DEFINE_DIR2_EVENT(xfs_dir2_node_replace)
+DEFINE_DIR2_EVENT(xfs_dir2_node_removename)
+DEFINE_DIR2_EVENT(xfs_dir2_node_to_leaf)
 
 DECLARE_EVENT_CLASS(xfs_dir2_space_class,
 	TP_PROTO(struct xfs_da_args *args, int idx),
@@ -1538,10 +1538,10 @@ DECLARE_EVENT_CLASS(xfs_dir2_space_class
 DEFINE_EVENT(xfs_dir2_space_class, name, \
 	TP_PROTO(struct xfs_da_args *args, int idx), \
 	TP_ARGS(args, idx))
-DEFINE_DIR2_SPACE_EVENT(xfs_dir2_leafn_add);
-DEFINE_DIR2_SPACE_EVENT(xfs_dir2_leafn_remove);
-DEFINE_DIR2_SPACE_EVENT(xfs_dir2_grow_inode);
-DEFINE_DIR2_SPACE_EVENT(xfs_dir2_shrink_inode);
+DEFINE_DIR2_SPACE_EVENT(xfs_dir2_leafn_add)
+DEFINE_DIR2_SPACE_EVENT(xfs_dir2_leafn_remove)
+DEFINE_DIR2_SPACE_EVENT(xfs_dir2_grow_inode)
+DEFINE_DIR2_SPACE_EVENT(xfs_dir2_shrink_inode)
 
 TRACE_EVENT(xfs_dir2_leafn_moveents,
 	TP_PROTO(struct xfs_da_args *args, int src_idx, int dst_idx, int count),
@@ -1570,7 +1570,7 @@ TRACE_EVENT(xfs_dir2_leafn_moveents,
 		  __entry->src_idx,
 		  __entry->dst_idx,
 		  __entry->count)
-);
+)
 
 #define XFS_SWAPEXT_INODES \
 	{ 0,	"target" }, \
@@ -1622,8 +1622,8 @@ DEFINE_EVENT(xfs_swap_extent_class, name
 	TP_PROTO(struct xfs_inode *ip, int which), \
 	TP_ARGS(ip, which))
 
-DEFINE_SWAPEXT_EVENT(xfs_swap_extent_before);
-DEFINE_SWAPEXT_EVENT(xfs_swap_extent_after);
+DEFINE_SWAPEXT_EVENT(xfs_swap_extent_before)
+DEFINE_SWAPEXT_EVENT(xfs_swap_extent_after)
 
 DECLARE_EVENT_CLASS(xfs_log_recover_item_class,
 	TP_PROTO(struct log *log, struct xlog_recover *trans,
@@ -1664,11 +1664,11 @@ DEFINE_EVENT(xfs_log_recover_item_class,
 		struct xlog_recover_item *item, int pass), \
 	TP_ARGS(log, trans, item, pass))
 
-DEFINE_LOG_RECOVER_ITEM(xfs_log_recover_item_add);
-DEFINE_LOG_RECOVER_ITEM(xfs_log_recover_item_add_cont);
-DEFINE_LOG_RECOVER_ITEM(xfs_log_recover_item_reorder_head);
-DEFINE_LOG_RECOVER_ITEM(xfs_log_recover_item_reorder_tail);
-DEFINE_LOG_RECOVER_ITEM(xfs_log_recover_item_recover);
+DEFINE_LOG_RECOVER_ITEM(xfs_log_recover_item_add)
+DEFINE_LOG_RECOVER_ITEM(xfs_log_recover_item_add_cont)
+DEFINE_LOG_RECOVER_ITEM(xfs_log_recover_item_reorder_head)
+DEFINE_LOG_RECOVER_ITEM(xfs_log_recover_item_reorder_tail)
+DEFINE_LOG_RECOVER_ITEM(xfs_log_recover_item_recover)
 
 DECLARE_EVENT_CLASS(xfs_log_recover_buf_item_class,
 	TP_PROTO(struct log *log, struct xfs_buf_log_format *buf_f),
@@ -1704,14 +1704,14 @@ DEFINE_EVENT(xfs_log_recover_buf_item_cl
 	TP_PROTO(struct log *log, struct xfs_buf_log_format *buf_f), \
 	TP_ARGS(log, buf_f))
 
-DEFINE_LOG_RECOVER_BUF_ITEM(xfs_log_recover_buf_not_cancel);
-DEFINE_LOG_RECOVER_BUF_ITEM(xfs_log_recover_buf_cancel);
-DEFINE_LOG_RECOVER_BUF_ITEM(xfs_log_recover_buf_cancel_add);
-DEFINE_LOG_RECOVER_BUF_ITEM(xfs_log_recover_buf_cancel_ref_inc);
-DEFINE_LOG_RECOVER_BUF_ITEM(xfs_log_recover_buf_recover);
-DEFINE_LOG_RECOVER_BUF_ITEM(xfs_log_recover_buf_inode_buf);
-DEFINE_LOG_RECOVER_BUF_ITEM(xfs_log_recover_buf_reg_buf);
-DEFINE_LOG_RECOVER_BUF_ITEM(xfs_log_recover_buf_dquot_buf);
+DEFINE_LOG_RECOVER_BUF_ITEM(xfs_log_recover_buf_not_cancel)
+DEFINE_LOG_RECOVER_BUF_ITEM(xfs_log_recover_buf_cancel)
+DEFINE_LOG_RECOVER_BUF_ITEM(xfs_log_recover_buf_cancel_add)
+DEFINE_LOG_RECOVER_BUF_ITEM(xfs_log_recover_buf_cancel_ref_inc)
+DEFINE_LOG_RECOVER_BUF_ITEM(xfs_log_recover_buf_recover)
+DEFINE_LOG_RECOVER_BUF_ITEM(xfs_log_recover_buf_inode_buf)
+DEFINE_LOG_RECOVER_BUF_ITEM(xfs_log_recover_buf_reg_buf)
+DEFINE_LOG_RECOVER_BUF_ITEM(xfs_log_recover_buf_dquot_buf)
 
 DECLARE_EVENT_CLASS(xfs_log_recover_ino_item_class,
 	TP_PROTO(struct log *log, struct xfs_inode_log_format *in_f),
@@ -1755,9 +1755,9 @@ DEFINE_EVENT(xfs_log_recover_ino_item_cl
 	TP_PROTO(struct log *log, struct xfs_inode_log_format *in_f), \
 	TP_ARGS(log, in_f))
 
-DEFINE_LOG_RECOVER_INO_ITEM(xfs_log_recover_inode_recover);
-DEFINE_LOG_RECOVER_INO_ITEM(xfs_log_recover_inode_cancel);
-DEFINE_LOG_RECOVER_INO_ITEM(xfs_log_recover_inode_skip);
+DEFINE_LOG_RECOVER_INO_ITEM(xfs_log_recover_inode_recover)
+DEFINE_LOG_RECOVER_INO_ITEM(xfs_log_recover_inode_cancel)
+DEFINE_LOG_RECOVER_INO_ITEM(xfs_log_recover_inode_skip)
 
 DECLARE_EVENT_CLASS(xfs_discard_class,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
@@ -1787,10 +1787,10 @@ DEFINE_EVENT(xfs_discard_class, name, \
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
 		 xfs_agblock_t agbno, xfs_extlen_t len), \
 	TP_ARGS(mp, agno, agbno, len))
-DEFINE_DISCARD_EVENT(xfs_discard_extent);
-DEFINE_DISCARD_EVENT(xfs_discard_toosmall);
-DEFINE_DISCARD_EVENT(xfs_discard_exclude);
-DEFINE_DISCARD_EVENT(xfs_discard_busy);
+DEFINE_DISCARD_EVENT(xfs_discard_extent)
+DEFINE_DISCARD_EVENT(xfs_discard_toosmall)
+DEFINE_DISCARD_EVENT(xfs_discard_exclude)
+DEFINE_DISCARD_EVENT(xfs_discard_busy)
 
 #endif /* _TRACE_XFS_H */
 

